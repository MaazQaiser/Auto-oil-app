import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/sync/sync_collections.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../domain/entities/reminder_history_entry.dart';

class ReminderHistoryDataSource {
  ReminderHistoryDataSource(this._db, [this._sync = const NoopSyncQueue()]);

  final AppDatabase _db;
  final SyncQueue _sync;

  ReminderHistoryEntry _map(ReminderHistoryRow row) {
    return ReminderHistoryEntry(
      id: row.id,
      reminderId: row.reminderId,
      vehicleId: row.vehicleId,
      customerId: row.customerId,
      actionType: ReminderHistoryAction.fromStorage(row.actionType),
      title: row.title,
      details: row.details,
      createdAt: row.createdAt,
    );
  }

  Future<void> insert(ReminderHistoryEntry entry) async {
    try {
      await _db.into(_db.reminderHistory).insert(
            ReminderHistoryCompanion.insert(
              id: entry.id,
              reminderId: Value(entry.reminderId),
              vehicleId: Value(entry.vehicleId),
              customerId: Value(entry.customerId),
              actionType: entry.actionType.storageValue,
              title: Value(entry.title),
              details: Value(entry.details),
              createdAt: entry.createdAt,
            ),
          );
      await _sync.enqueueUpsert(
        SyncCollections.reminderHistory,
        entry.id,
        SyncSerializers.reminderHistoryToMap(entry),
      );
    } catch (e) {
      throw DatabaseException('Failed to insert reminder history: $e');
    }
  }

  Future<List<ReminderHistoryEntry>> getRecent({int limit = 100}) async {
    final rows = await (_db.select(_db.reminderHistory)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
    return rows.map(_map).toList();
  }

  Stream<List<ReminderHistoryEntry>> watchRecent({int limit = 100}) {
    return (_db.select(_db.reminderHistory)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .watch()
        .map((rows) => rows.map(_map).toList());
  }

  Future<List<ReminderHistoryEntry>> getForReminder(String reminderId) async {
    final rows = await (_db.select(_db.reminderHistory)
          ..where((t) => t.reminderId.equals(reminderId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_map).toList();
  }

  Future<int> cleanupOlderThan(Duration age) async {
    final DateTime cutoff = DateTime.now().subtract(age);
    return (_db.delete(_db.reminderHistory)
          ..where((t) => t.createdAt.isSmallerThanValue(cutoff)))
        .go();
  }
}
