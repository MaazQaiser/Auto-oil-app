/// Queue for offline-first cloud mutations.
abstract class SyncQueue {
  /// Enqueue an upsert; local DB is already updated by the caller.
  Future<void> enqueueUpsert(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  );

  /// Enqueue a delete for a document that was removed locally.
  Future<void> enqueueDelete(String collection, String documentId);

  /// Kick off a background flush/pull if online.
  void scheduleSync();
}

/// No-op queue used before auth or in tests.
class NoopSyncQueue implements SyncQueue {
  const NoopSyncQueue();

  @override
  Future<void> enqueueUpsert(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {}

  @override
  Future<void> enqueueDelete(String collection, String documentId) async {}

  @override
  void scheduleSync() {}
}
