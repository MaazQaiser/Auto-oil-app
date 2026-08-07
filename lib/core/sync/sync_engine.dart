import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../config/firebase_bootstrap.dart';
import '../utils/logger.dart';
import 'firestore_remote_datasource.dart';
import 'local_sync_mirror.dart';
import 'sync_collections.dart';
import 'sync_outbox_datasource.dart';
import 'sync_queue.dart';
import 'sync_serializers.dart';

enum SyncStatus { idle, syncing, offline, error }

/// Offline-first sync with incremental pull, last-write-wins conflict
/// resolution, tombstone deletes, and resilient background flushing.
class SyncEngine implements SyncQueue {
  SyncEngine({
    required SyncOutboxDataSource outbox,
    required FirestoreRemoteDataSource remote,
    required LocalSyncMirror mirror,
    FirebaseAuth? auth,
    Connectivity? connectivity,
  })  : _outbox = outbox,
        _remote = remote,
        _mirror = mirror,
        _auth = auth ?? FirebaseBootstrap.auth,
        _connectivity = connectivity ?? Connectivity();

  final SyncOutboxDataSource _outbox;
  final FirestoreRemoteDataSource _remote;
  final LocalSyncMirror _mirror;
  final FirebaseAuth? _auth;
  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _periodicTimer;
  bool _running = false;
  bool _scheduled = false;
  bool _pendingResync = false;
  SyncStatus _status = SyncStatus.idle;
  String? _lastError;
  int _pendingUploads = 0;

  SyncStatus get status => _status;
  String? get lastError => _lastError;
  int get pendingUploads => _pendingUploads;

  final StreamController<SyncStatus> _statusController =
      StreamController<SyncStatus>.broadcast();

  Stream<SyncStatus> get statusStream => _statusController.stream;

  static const List<String> _pullOrder = [
    SyncCollections.customers,
    SyncCollections.vehicles,
    SyncCollections.serviceRecords,
    SyncCollections.maintenanceReminders,
    SyncCollections.invoices,
    SyncCollections.inventoryItems,
    SyncCollections.messageTemplates,
    SyncCollections.maintenanceLogs,
    SyncCollections.reminderHistory,
  ];

  void start() {
    _connectivitySub ??=
        _connectivity.onConnectivityChanged.listen((results) {
      if (_hasNetwork(results)) {
        scheduleSync();
      } else {
        _setStatus(SyncStatus.offline);
      }
    });

    _periodicTimer ??= Timer.periodic(
      SyncConfig.foregroundInterval,
      (_) => scheduleSync(),
    );

    scheduleSync();
  }

  void dispose() {
    _connectivitySub?.cancel();
    _connectivitySub = null;
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _statusController.close();
  }

  @override
  Future<void> enqueueUpsert(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    final Map<String, dynamic> payload = Map<String, dynamic>.from(data)
      ..['updatedAt'] = (data['updatedAt'] as String?) ??
          DateTime.now().toUtc().toIso8601String();
    await _outbox.enqueueUpsert(
      collection: collection,
      documentId: documentId,
      data: payload,
    );
    scheduleSync();
  }

  @override
  Future<void> enqueueDelete(String collection, String documentId) async {
    await _outbox.enqueueDelete(
      collection: collection,
      documentId: documentId,
    );
    scheduleSync();
  }

  @override
  void scheduleSync() {
    if (_scheduled) {
      _pendingResync = true;
      return;
    }
    _scheduled = true;
    scheduleMicrotask(() async {
      _scheduled = false;
      await syncNow();
      if (_pendingResync) {
        _pendingResync = false;
        scheduleSync();
      }
    });
  }

  Future<void> syncNow() async {
    if (_running) {
      _pendingResync = true;
      return;
    }

    final User? user = _auth?.currentUser;
    if (user == null) {
      _setStatus(SyncStatus.idle);
      return;
    }

    if (!await _isOnline()) {
      _setStatus(SyncStatus.offline);
      return;
    }

    _running = true;
    _setStatus(SyncStatus.syncing);

    try {
      await _ensureInitialPush(user.uid);
      await _flushOutbox(user.uid);
      await _pullIncremental(user.uid);
      if (await _shouldReconcile()) {
        await _reconcileDeletions(user.uid);
      }

      _pendingUploads = await _outbox.pendingCount();
      await _outbox.setMeta(
        SyncMetaKeys.lastSyncedAt,
        DateTime.now().toUtc().toIso8601String(),
      );
      await _incrementSyncCycle();

      _setStatus(SyncStatus.idle);
      AppLogger.info(
        'Sync completed uid=${user.uid} pending=$_pendingUploads',
      );
    } catch (e, st) {
      _lastError = e.toString();
      _pendingUploads = await _outbox.pendingCount();
      _setStatus(SyncStatus.idle);
      AppLogger.error('Sync cycle error (will retry)', error: e, stackTrace: st);
    } finally {
      _running = false;
      _pendingUploads = await _outbox.pendingCount();
    }
  }

  Future<void> _ensureInitialPush(String uid) async {
    final flag = await _outbox.getMeta(SyncMetaKeys.initialPushDone);
    if (flag == '1') return;

    final hasRemote = await _remote.collectionHasDocs(
      uid: uid,
      collection: SyncCollections.customers,
    );
    if (hasRemote) {
      await _outbox.setMeta(SyncMetaKeys.initialPushDone, '1');
      return;
    }

    final local = await _mirror.exportAllLocal();
    var pushed = 0;
    for (final entry in local.entries) {
      for (final doc in entry.value) {
        final String id = doc['id'] as String;
        try {
          await _remote.upsert(
            uid: uid,
            collection: entry.key,
            documentId: id,
            data: doc,
          );
          pushed++;
          await _outbox.setMeta(
            SyncMetaKeys.pullCursor(entry.key),
            DateTime.now().toUtc().toIso8601String(),
          );
        } catch (e, st) {
          AppLogger.error(
            'Initial push failed ${entry.key}/$id',
            error: e,
            stackTrace: st,
          );
        }
      }
    }
    await _outbox.setMeta(SyncMetaKeys.initialPushDone, '1');
    AppLogger.info('Initial cloud seed pushed $pushed documents');
  }

  Future<void> _flushOutbox(String uid) async {
    final pending = await _outbox.pending();
    for (final row in pending) {
      if (row.attempts >= SyncConfig.maxOutboxAttempts) {
        AppLogger.warning(
          'Skipping outbox ${row.collection}/${row.documentId} — max attempts',
        );
        continue;
      }

      try {
        if (row.operation == SyncOperations.delete) {
          await _remote.tombstone(
            uid: uid,
            collection: row.collection,
            documentId: row.documentId,
            updatedAt: DateTime.now().toUtc(),
          );
          await _outbox.remove(row.id);
          continue;
        }

        final Map<String, dynamic> payload = row.payloadJson == null
            ? <String, dynamic>{'id': row.documentId}
            : SyncSerializers.decodePayload(row.payloadJson!);
        final DateTime localUpdated = SyncSerializers.updatedAtFromMap(payload);

        final Map<String, dynamic>? remote = await _remote.fetchDocument(
          uid: uid,
          collection: row.collection,
          documentId: row.documentId,
        );

        if (remote != null) {
          if (SyncSerializers.isTombstone(remote)) {
            await _outbox.remove(row.id);
            await _mirror.applyRemoteDoc(
              collection: row.collection,
              data: remote,
            );
            continue;
          }

          final DateTime remoteUpdated = SyncSerializers.updatedAtFromMap(remote);
          if (remoteUpdated.isAfter(localUpdated)) {
            AppLogger.info(
              'Remote wins ${row.collection}/${row.documentId} — dropping stale outbox',
            );
            await _outbox.remove(row.id);
            await _mirror.applyRemoteDoc(
              collection: row.collection,
              data: remote,
            );
            continue;
          }
        }

        await _remote.upsert(
          uid: uid,
          collection: row.collection,
          documentId: row.documentId,
          data: payload,
        );
        await _outbox.remove(row.id);
      } catch (e, st) {
        await _outbox.markFailed(row.id, e.toString());
        _lastError = e.toString();
        AppLogger.error(
          'Outbox flush failed ${row.collection}/${row.documentId}',
          error: e,
          stackTrace: st,
        );
      }
    }
  }

  Future<void> _pullIncremental(String uid) async {
    for (final collection in _pullOrder) {
      try {
        final DateTime? since = await _readPullCursor(collection);
        final docs = await _remote.fetchChangedSince(
          uid: uid,
          collection: collection,
          since: since,
        );

        DateTime? maxUpdated;
        for (final doc in docs) {
          await _mirror.applyRemoteDoc(collection: collection, data: doc);
          if (!SyncSerializers.isTombstone(doc)) {
            final DateTime updated = SyncSerializers.updatedAtFromMap(doc);
            if (maxUpdated == null || updated.isAfter(maxUpdated)) {
              maxUpdated = updated;
            }
          }
        }

        if (maxUpdated != null) {
          await _outbox.setMeta(
            SyncMetaKeys.pullCursor(collection),
            maxUpdated.toUtc().toIso8601String(),
          );
        } else if (since == null && docs.isNotEmpty) {
          await _outbox.setMeta(
            SyncMetaKeys.pullCursor(collection),
            DateTime.now().toUtc().toIso8601String(),
          );
        }

        AppLogger.info(
          'Pulled ${docs.length} changed doc(s) from $collection',
        );
      } catch (e, st) {
        _lastError = e.toString();
        AppLogger.error('Pull failed for $collection', error: e, stackTrace: st);
      }
    }
  }

  Future<DateTime?> _readPullCursor(String collection) async {
    final raw = await _outbox.getMeta(SyncMetaKeys.pullCursor(collection));
    if (raw == null || raw.isEmpty) return null;
    final parsed = DateTime.tryParse(raw)?.toUtc();
    if (parsed == null) return null;
    return parsed.subtract(SyncConfig.pullOverlap);
  }

  Future<bool> _shouldReconcile() async {
    final cycleRaw = await _outbox.getMeta(SyncMetaKeys.syncCycleCount);
    final cycle = int.tryParse(cycleRaw ?? '') ?? 0;
    if (cycle > 0 && cycle % SyncConfig.reconcileEveryNCycles == 0) {
      return true;
    }

    final lastRaw = await _outbox.getMeta(SyncMetaKeys.lastReconcileAt);
    if (lastRaw == null) return true;
    final last = DateTime.tryParse(lastRaw)?.toUtc();
    if (last == null) return true;
    return DateTime.now().toUtc().difference(last) >= SyncConfig.reconcileInterval;
  }

  Future<void> _reconcileDeletions(String uid) async {
    for (final collection in _pullOrder) {
      try {
        final remoteIds = await _remote.fetchAllDocumentIds(
          uid: uid,
          collection: collection,
        );
        final localIds = await _mirror.listLocalIds(collection);
        final pendingIds = await _outbox.pendingDocumentIds(collection);

        for (final localId in localIds) {
          if (remoteIds.contains(localId)) continue;
          if (pendingIds.contains(localId)) continue;
          await _mirror.applyRemoteDelete(
            collection: collection,
            documentId: localId,
          );
          AppLogger.info('Reconciled orphan local $collection/$localId');
        }
      } catch (e, st) {
        AppLogger.error(
          'Reconcile failed for $collection',
          error: e,
          stackTrace: st,
        );
      }
    }

    await _outbox.setMeta(
      SyncMetaKeys.lastReconcileAt,
      DateTime.now().toUtc().toIso8601String(),
    );
  }

  Future<void> _incrementSyncCycle() async {
    final raw = await _outbox.getMeta(SyncMetaKeys.syncCycleCount);
    final next = (int.tryParse(raw ?? '') ?? 0) + 1;
    await _outbox.setMeta(SyncMetaKeys.syncCycleCount, '$next');
  }

  Future<bool> _isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return _hasNetwork(results);
  }

  bool _hasNetwork(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) => r != ConnectivityResult.none);
  }

  void _setStatus(SyncStatus status) {
    _status = status;
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }
}
