import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import 'sync_collections.dart';
import 'sync_serializers.dart';

class SyncOutboxDataSource {
  SyncOutboxDataSource(this._db);

  final AppDatabase _db;
  static const Uuid _uuid = Uuid();

  Future<void> enqueueUpsert({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    // Collapse pending upserts for the same document.
    await (_db.delete(_db.syncOutbox)
          ..where(
            (t) =>
                t.collection.equals(collection) &
                t.documentId.equals(documentId),
          ))
        .go();

    await _db.into(_db.syncOutbox).insert(
          SyncOutboxCompanion.insert(
            id: _uuid.v4(),
            collection: collection,
            documentId: documentId,
            operation: SyncOperations.upsert,
            payloadJson: Value(SyncSerializers.encodePayload(data)),
            createdAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<void> enqueueDelete({
    required String collection,
    required String documentId,
  }) async {
    await (_db.delete(_db.syncOutbox)
          ..where(
            (t) =>
                t.collection.equals(collection) &
                t.documentId.equals(documentId),
          ))
        .go();

    await _db.into(_db.syncOutbox).insert(
          SyncOutboxCompanion.insert(
            id: _uuid.v4(),
            collection: collection,
            documentId: documentId,
            operation: SyncOperations.delete,
            createdAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<List<SyncOutboxRow>> pending({int limit = 200}) {
    return (_db.select(_db.syncOutbox)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<bool> hasPendingForDocument({
    required String collection,
    required String documentId,
  }) async {
    final row = await (_db.select(_db.syncOutbox)
          ..where(
            (t) =>
                t.collection.equals(collection) &
                t.documentId.equals(documentId),
          )
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  Future<Set<String>> pendingDocumentIds(String collection) async {
    final rows = await (_db.select(_db.syncOutbox)
          ..where((t) => t.collection.equals(collection)))
        .get();
    return rows.map((r) => r.documentId).toSet();
  }

  Future<void> removeForDocument({
    required String collection,
    required String documentId,
  }) async {
    await (_db.delete(_db.syncOutbox)
          ..where(
            (t) =>
                t.collection.equals(collection) &
                t.documentId.equals(documentId),
          ))
        .go();
  }

  Future<void> remove(String id) async {
    await (_db.delete(_db.syncOutbox)..where((t) => t.id.equals(id))).go();
  }

  Future<void> markFailed(String id, String error) async {
    final row = await (_db.select(_db.syncOutbox)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;
    await (_db.update(_db.syncOutbox)..where((t) => t.id.equals(id))).write(
      SyncOutboxCompanion(
        attempts: Value(row.attempts + 1),
        lastError: Value(error),
      ),
    );
  }

  Future<int> pendingCount() async {
    final countExp = _db.syncOutbox.id.count();
    final row = await (_db.selectOnly(_db.syncOutbox)..addColumns([countExp]))
        .getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<String?> getMeta(String key) async {
    final row = await (_db.select(_db.syncMeta)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setMeta(String key, String value) async {
    await _db.into(_db.syncMeta).insertOnConflictUpdate(
          SyncMetaCompanion.insert(
            key: key,
            value: value,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
  }
}
