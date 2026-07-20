import '../../../../core/errors/exceptions.dart';
import '../../../../core/sync/sync_collections.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../../../core/utils/logger.dart';
import '../../../reminders/domain/services/reminder_service.dart';
import '../../domain/entities/service_record.dart';
import '../../domain/repositories/service_record_repository.dart';
import '../datasources/service_record_local_datasource.dart';

class ServiceRecordRepositoryImpl implements ServiceRecordRepository {
  ServiceRecordRepositoryImpl(
    this._dataSource,
    this._reminderService, [
    this._sync = const NoopSyncQueue(),
  ]);

  final ServiceRecordLocalDataSource _dataSource;
  final ReminderService _reminderService;
  final SyncQueue _sync;

  Future<void> _enqueue(ServiceRecord record) {
    return _sync.enqueueUpsert(
      SyncCollections.serviceRecords,
      record.id,
      SyncSerializers.serviceRecordToMap(record),
    );
  }

  @override
  Future<ServiceRecord> createServiceRecord(ServiceRecord record) async {
    try {
      final created = await _dataSource.insert(record);
      await _enqueue(created);
      await _reminderService.syncFromServiceRecord(created);
      AppLogger.info('Service record created: ${created.id}');
      return created;
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('createServiceRecord failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to create service record');
    }
  }

  @override
  Future<ServiceRecord> updateServiceRecord(ServiceRecord record) async {
    try {
      final updated = await _dataSource.update(
        ServiceRecord(
          id: record.id,
          vehicleId: record.vehicleId,
          serviceDate: record.serviceDate,
          odometerReading: record.odometerReading,
          serviceType: record.serviceType,
          description: record.description,
          oilBrand: record.oilBrand,
          laborCost: record.laborCost,
          partsCost: record.partsCost,
          totalCost: record.totalCost,
          notes: record.notes,
          reminderType: record.reminderType,
          nextServiceOdometer: record.nextServiceOdometer,
          nextServiceDate: record.nextServiceDate,
          reminderEnabled: record.reminderEnabled,
          whatsappEnabled: record.whatsappEnabled,
          createdAt: record.createdAt,
          updatedAt: DateTime.now(),
          isArchived: record.isArchived,
        ),
      );
      await _enqueue(updated);
      await _reminderService.syncFromServiceRecord(updated);
      return updated;
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('updateServiceRecord failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to update service record');
    }
  }

  @override
  Future<void> deleteServiceRecord(String id) async {
    try {
      await _reminderService.deleteForServiceRecord(id);
      await _dataSource.delete(id);
      await _sync.enqueueDelete(SyncCollections.serviceRecords, id);
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('deleteServiceRecord failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to delete service record');
    }
  }

  @override
  Future<ServiceRecord?> getById(String id) => _dataSource.getById(id);

  @override
  Future<List<ServiceRecord>> getByVehicle(String vehicleId) {
    return _dataSource.getByVehicle(vehicleId);
  }

  @override
  Stream<List<ServiceRecord>> watchByVehicle(String vehicleId) {
    return _dataSource.watchByVehicle(vehicleId);
  }

  @override
  Future<double> totalRevenue() => _dataSource.totalRevenue();
}
