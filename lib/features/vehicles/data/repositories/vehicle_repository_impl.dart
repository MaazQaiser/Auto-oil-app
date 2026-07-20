import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/sync/sync_collections.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_local_datasource.dart';

/// Drift-backed implementation of [VehicleRepository] with Firebase sync.
class VehicleRepositoryImpl implements VehicleRepository {
  VehicleRepositoryImpl(this._dataSource, [this._sync = const NoopSyncQueue()]);

  final VehicleLocalDataSource _dataSource;
  final SyncQueue _sync;

  Future<void> _enqueue(Vehicle vehicle) {
    return _sync.enqueueUpsert(
      SyncCollections.vehicles,
      vehicle.id,
      SyncSerializers.vehicleToMap(vehicle),
    );
  }

  @override
  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    try {
      final bool taken = await _dataSource.isRegistrationTaken(
        vehicle.registrationNumber,
      );
      if (taken) {
        throw const ValidationException(
          'A vehicle with this registration number already exists',
          code: 'duplicate_registration',
        );
      }
      final Vehicle created = await _dataSource.insert(vehicle);
      await _enqueue(created);
      AppLogger.info('Vehicle created: ${created.id}');
      return created;
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('createVehicle failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to create vehicle');
    }
  }

  @override
  Future<Vehicle> updateVehicle(Vehicle vehicle) async {
    try {
      final bool taken = await _dataSource.isRegistrationTaken(
        vehicle.registrationNumber,
        excludeId: vehicle.id,
      );
      if (taken) {
        throw const ValidationException(
          'A vehicle with this registration number already exists',
          code: 'duplicate_registration',
        );
      }
      final Vehicle updated = await _dataSource.update(
        vehicle.copyWith(updatedAt: DateTime.now()),
      );
      await _enqueue(updated);
      AppLogger.info('Vehicle updated: ${updated.id}');
      return updated;
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('updateVehicle failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to update vehicle');
    }
  }

  @override
  Future<void> deleteVehicle(String id) => archiveVehicle(id);

  @override
  Future<void> archiveVehicle(String id) async {
    try {
      await _dataSource.setArchived(id, archived: true);
      final Vehicle? vehicle = await _dataSource.getById(id);
      if (vehicle != null) await _enqueue(vehicle);
      AppLogger.info('Vehicle archived: $id');
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('archiveVehicle failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to archive vehicle');
    }
  }

  @override
  Future<void> restoreVehicle(String id) async {
    try {
      await _dataSource.setArchived(id, archived: false);
      final Vehicle? vehicle = await _dataSource.getById(id);
      if (vehicle != null) await _enqueue(vehicle);
      AppLogger.info('Vehicle restored: $id');
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('restoreVehicle failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to restore vehicle');
    }
  }

  @override
  Future<Vehicle?> getVehicleById(String id) async {
    try {
      return await _dataSource.getById(id);
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('getVehicleById failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to get vehicle');
    }
  }

  @override
  Future<List<Vehicle>> getVehiclesByCustomer(
    String customerId, {
    bool archived = false,
  }) async {
    try {
      return await _dataSource.getByCustomer(
        customerId,
        archived: archived,
      );
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('getVehiclesByCustomer failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to load customer vehicles');
    }
  }

  @override
  Future<List<Vehicle>> getAllVehicles({bool archived = false}) async {
    try {
      return await _dataSource.getAll(archived: archived);
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('getAllVehicles failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to load vehicles');
    }
  }

  @override
  Future<List<Vehicle>> searchVehicles(
    String query, {
    bool archived = false,
  }) async {
    try {
      if (query.trim().isEmpty) {
        return getAllVehicles(archived: archived);
      }
      return await _dataSource.search(query, archived: archived);
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('searchVehicles failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to search vehicles');
    }
  }

  @override
  Stream<List<Vehicle>> watchActiveVehicles() {
    return _dataSource.watchAll(archived: false);
  }

  @override
  Stream<List<Vehicle>> watchArchivedVehicles() {
    return _dataSource.watchAll(archived: true);
  }

  @override
  Stream<List<Vehicle>> watchVehiclesByCustomer(String customerId) {
    return _dataSource.watchByCustomer(customerId);
  }

  @override
  Future<bool> isRegistrationTaken(
    String registrationNumber, {
    String? excludeId,
  }) {
    return _dataSource.isRegistrationTaken(
      registrationNumber,
      excludeId: excludeId,
    );
  }

  @override
  Future<int> countActiveVehicles() => _dataSource.countActive();

  @override
  Future<int> countVehiclesByCustomer(String customerId) {
    return _dataSource.countByCustomer(customerId);
  }
}

Failure mapVehicleException(Object error) {
  if (error is ValidationException) {
    return ValidationFailure(message: error.message, code: error.code);
  }
  if (error is NotFoundException) {
    return UnexpectedFailure(message: error.message, code: error.code);
  }
  if (error is DatabaseException) {
    return DatabaseFailure(message: error.message, code: error.code);
  }
  return const UnexpectedFailure();
}
