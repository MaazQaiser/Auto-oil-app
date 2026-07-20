import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/logger.dart';
import 'firestore_remote_datasource.dart';
import 'local_sync_mirror.dart';
import 'sync_collections.dart';
import 'sync_outbox_datasource.dart';
import 'sync_queue.dart';
import 'sync_serializers.dart';

enum SyncStatus { idle, syncing, offline, error }

/// Offline-first sync: local Drift is source of truth for UI/search;
/// mutations go to an outbox and flush to Firestore when online.
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
        _auth = auth ?? FirebaseAuth.instance,
        _connectivity = connectivity ?? Connectivity();

  final SyncOutboxDataSource _outbox;
  final FirestoreRemoteDataSource _remote;
  final LocalSyncMirror _mirror;
  final FirebaseAuth _auth;
  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _running = false;
  bool _scheduled = false;
  SyncStatus _status = SyncStatus.idle;
  String? _lastError;

  SyncStatus get status => _status;
  String? get lastError => _lastError;

  final StreamController<SyncStatus> _statusController =
      StreamController<SyncStatus>.broadcast();

  Stream<SyncStatus> get statusStream => _statusController.stream;

  void start() {
    _connectivitySub ??=
        _connectivity.onConnectivityChanged.listen((results) {
      if (_hasNetwork(results)) {
        scheduleSync();
      } else {
        _setStatus(SyncStatus.offline);
      }
    });
    scheduleSync();
  }

  void dispose() {
    _connectivitySub?.cancel();
    _connectivitySub = null;
    _statusController.close();
  }

  @override
  Future<void> enqueueUpsert(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    await _outbox.enqueueUpsert(
      collection: collection,
      documentId: documentId,
      data: data,
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
    if (_scheduled) return;
    _scheduled = true;
    scheduleMicrotask(() async {
      _scheduled = false;
      await syncNow();
    });
  }

  Future<void> syncNow() async {
    if (_running) return;
    final User? user = _auth.currentUser;
    if (user == null) {
      _setStatus(SyncStatus.idle);
      return;
    }

    final online = await _isOnline();
    if (!online) {
      _setStatus(SyncStatus.offline);
      return;
    }

    _running = true;
    _setStatus(SyncStatus.syncing);
    try {
      await _ensureInitialPush(user.uid);
      await _flushOutbox(user.uid);
      await _pullAll(user.uid);
      await _outbox.setMeta(
        SyncMetaKeys.lastSyncedAt,
        DateTime.now().toUtc().toIso8601String(),
      );
      _lastError = null;
      _setStatus(SyncStatus.idle);
      AppLogger.info('Sync completed for uid=${user.uid}');
    } catch (e, st) {
      _lastError = e.toString();
      _setStatus(SyncStatus.error);
      AppLogger.error('Sync failed', error: e, stackTrace: st);
    } finally {
      _running = false;
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
        await _remote.upsert(
          uid: uid,
          collection: entry.key,
          documentId: id,
          data: doc,
        );
        pushed++;
      }
    }
    await _outbox.setMeta(SyncMetaKeys.initialPushDone, '1');
    AppLogger.info('Initial cloud seed pushed $pushed documents');
  }

  Future<void> _flushOutbox(String uid) async {
    final pending = await _outbox.pending();
    for (final row in pending) {
      try {
        if (row.operation == SyncOperations.delete) {
          await _remote.delete(
            uid: uid,
            collection: row.collection,
            documentId: row.documentId,
          );
        } else {
          final payload = row.payloadJson == null
              ? <String, dynamic>{'id': row.documentId}
              : SyncSerializers.decodePayload(row.payloadJson!);
          await _remote.upsert(
            uid: uid,
            collection: row.collection,
            documentId: row.documentId,
            data: payload,
          );
        }
        await _outbox.remove(row.id);
      } catch (e) {
        await _outbox.markFailed(row.id, e.toString());
        rethrow;
      }
    }
  }

  Future<void> _pullAll(String uid) async {
    // Pull parents before children to satisfy local FK constraints.
    const order = [
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

    for (final collection in order) {
      final docs = await _remote.fetchAll(uid: uid, collection: collection);
      for (final doc in docs) {
        await _mirror.applyRemoteDoc(collection: collection, data: doc);
      }
    }
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
