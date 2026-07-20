import '../../../../core/errors/exceptions.dart';
import '../../../../core/sync/sync_collections.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/maintenance_reminder.dart';
import '../../domain/entities/reminder_enums.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_local_datasource.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl(this._dataSource, [this._sync = const NoopSyncQueue()]);

  final ReminderLocalDataSource _dataSource;
  final SyncQueue _sync;

  Future<void> _enqueue(MaintenanceReminder reminder) {
    return _sync.enqueueUpsert(
      SyncCollections.maintenanceReminders,
      reminder.id,
      SyncSerializers.reminderToMap(reminder),
    );
  }

  @override
  Future<MaintenanceReminder> createReminder(MaintenanceReminder reminder) async {
    try {
      final created = await _dataSource.insert(reminder);
      await _enqueue(created);
      return created;
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('createReminder failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to create reminder');
    }
  }

  @override
  Future<MaintenanceReminder> updateReminder(MaintenanceReminder reminder) async {
    try {
      final updated = await _dataSource.update(reminder);
      await _enqueue(updated);
      return updated;
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('updateReminder failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to update reminder');
    }
  }

  @override
  Future<void> deleteReminder(String id) async {
    await _dataSource.delete(id);
    await _sync.enqueueDelete(SyncCollections.maintenanceReminders, id);
  }

  @override
  Future<void> deleteByServiceRecordId(String serviceRecordId) async {
    final ids = await _dataSource.deleteByServiceRecordId(serviceRecordId);
    for (final id in ids) {
      await _sync.enqueueDelete(SyncCollections.maintenanceReminders, id);
    }
  }

  @override
  Future<MaintenanceReminder?> getById(String id) => _dataSource.getById(id);

  @override
  Future<MaintenanceReminder?> getByServiceRecordId(String serviceRecordId) {
    return _dataSource.getByServiceRecordId(serviceRecordId);
  }

  @override
  Future<List<MaintenanceReminder>> getAll({ReminderStatus? status}) {
    return _dataSource.getAll(status: status);
  }

  @override
  Future<List<MaintenanceReminder>> getByVehicle(String vehicleId) {
    return _dataSource.getByVehicle(vehicleId);
  }

  @override
  Future<MaintenanceReminder?> getActiveForVehicle(String vehicleId) {
    return _dataSource.getActiveForVehicle(vehicleId);
  }

  @override
  Stream<List<MaintenanceReminder>> watchAll() => _dataSource.watchAll();

  @override
  Stream<List<MaintenanceReminder>> watchByStatus(ReminderStatus status) {
    return _dataSource.watchByStatus(status);
  }

  @override
  Future<ReminderSummary> getSummary() => _dataSource.getSummary();

  @override
  Future<List<MaintenanceReminder>> search(String query) {
    return _dataSource.search(query);
  }

  @override
  Future<int> countByStatus(ReminderStatus status) {
    return _dataSource.countByStatus(status);
  }

  @override
  Future<int> recalculateAllStatuses() async {
    final updated = await _dataSource.recalculateAllStatuses();
    if (updated > 0) {
      final all = await _dataSource.getAll();
      for (final reminder in all) {
        if (reminder.status != ReminderStatus.completed) {
          await _enqueue(reminder);
        }
      }
    }
    return updated;
  }
}
