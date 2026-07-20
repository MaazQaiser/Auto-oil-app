import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_enums.dart';

/// Local Drift data source for vehicles.
class VehicleLocalDataSource {
  VehicleLocalDataSource(this._db);

  final AppDatabase _db;

  Vehicle _toEntity(VehicleRow row, {String? ownerName}) {
    return Vehicle(
      id: row.id,
      customerId: row.customerId,
      make: row.make,
      model: row.model,
      variant: row.variant,
      year: row.year,
      registrationNumber: row.registrationNumber,
      vinNumber: row.vinNumber,
      engineNumber: row.engineNumber,
      engineCapacity: row.engineCapacity,
      fuelType: FuelType.fromStorage(row.fuelType),
      transmission: TransmissionType.fromStorage(row.transmission),
      color: row.color,
      currentOdo: row.currentOdo,
      purchaseDate: row.purchaseDate,
      insuranceExpiry: row.insuranceExpiry,
      registrationExpiry: row.registrationExpiry,
      imagePath: row.imagePath,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isArchived: row.isArchived,
      ownerName: ownerName,
    );
  }

  VehiclesCompanion _toCompanion(Vehicle vehicle) {
    return VehiclesCompanion(
      id: Value(vehicle.id),
      customerId: Value(vehicle.customerId),
      make: Value(vehicle.make),
      model: Value(vehicle.model),
      variant: Value(vehicle.variant),
      year: Value(vehicle.year),
      registrationNumber: Value(vehicle.registrationNumber),
      vinNumber: Value(vehicle.vinNumber),
      engineNumber: Value(vehicle.engineNumber),
      engineCapacity: Value(vehicle.engineCapacity),
      fuelType: Value(vehicle.fuelType.name),
      transmission: Value(vehicle.transmission.name),
      color: Value(vehicle.color),
      currentOdo: Value(vehicle.currentOdo),
      purchaseDate: Value(vehicle.purchaseDate),
      insuranceExpiry: Value(vehicle.insuranceExpiry),
      registrationExpiry: Value(vehicle.registrationExpiry),
      imagePath: Value(vehicle.imagePath),
      notes: Value(vehicle.notes),
      createdAt: Value(vehicle.createdAt),
      updatedAt: Value(vehicle.updatedAt),
      isArchived: Value(vehicle.isArchived),
    );
  }

  Future<List<Vehicle>> _mapJoined(List<TypedResult> rows) async {
    return rows.map((row) {
      final VehicleRow vehicle = row.readTable(_db.vehicles);
      final CustomerRow customer = row.readTable(_db.customers);
      return _toEntity(vehicle, ownerName: customer.fullName);
    }).toList();
  }

  JoinedSelectStatement<HasResultSet, dynamic> _selectWithOwner({
    required bool archived,
  }) {
    return (_db.select(_db.vehicles).join([
      innerJoin(
        _db.customers,
        _db.customers.id.equalsExp(_db.vehicles.customerId),
      ),
    ])
      ..where(_db.vehicles.isArchived.equals(archived))
      ..orderBy([OrderingTerm.desc(_db.vehicles.updatedAt)]));
  }

  Future<Vehicle> insert(Vehicle vehicle) async {
    try {
      await _db.into(_db.vehicles).insert(_toCompanion(vehicle));
      final Vehicle? created = await getById(vehicle.id);
      return created ?? vehicle;
    } catch (e) {
      throw DatabaseException('Failed to create vehicle: $e');
    }
  }

  Future<Vehicle> update(Vehicle vehicle) async {
    try {
      final int updated = await (_db.update(_db.vehicles)
            ..where((t) => t.id.equals(vehicle.id)))
          .write(_toCompanion(vehicle));
      if (updated == 0) {
        throw const NotFoundException('Vehicle not found');
      }
      final Vehicle? result = await getById(vehicle.id);
      return result ?? vehicle;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to update vehicle: $e');
    }
  }

  Future<void> setArchived(String id, {required bool archived}) async {
    try {
      final int updated = await (_db.update(_db.vehicles)
            ..where((t) => t.id.equals(id)))
          .write(
        VehiclesCompanion(
          isArchived: Value(archived),
          updatedAt: Value(DateTime.now()),
        ),
      );
      if (updated == 0) {
        throw const NotFoundException('Vehicle not found');
      }
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to update vehicle archive state: $e');
    }
  }

  Future<Vehicle?> getById(String id) async {
    try {
      final query = _db.select(_db.vehicles).join([
        innerJoin(
          _db.customers,
          _db.customers.id.equalsExp(_db.vehicles.customerId),
        ),
      ])
        ..where(_db.vehicles.id.equals(id));
      final TypedResult? row = await query.getSingleOrNull();
      if (row == null) return null;
      final VehicleRow vehicle = row.readTable(_db.vehicles);
      final CustomerRow customer = row.readTable(_db.customers);
      return _toEntity(vehicle, ownerName: customer.fullName);
    } catch (e) {
      throw DatabaseException('Failed to get vehicle: $e');
    }
  }

  Future<List<Vehicle>> getByCustomer(
    String customerId, {
    required bool archived,
  }) async {
    try {
      final query = _db.select(_db.vehicles).join([
        innerJoin(
          _db.customers,
          _db.customers.id.equalsExp(_db.vehicles.customerId),
        ),
      ])
        ..where(
          _db.vehicles.customerId.equals(customerId) &
              _db.vehicles.isArchived.equals(archived),
        )
        ..orderBy([OrderingTerm.desc(_db.vehicles.updatedAt)]);
      return _mapJoined(await query.get());
    } catch (e) {
      throw DatabaseException('Failed to load customer vehicles: $e');
    }
  }

  Future<List<Vehicle>> getAll({required bool archived}) async {
    try {
      return _mapJoined(await _selectWithOwner(archived: archived).get());
    } catch (e) {
      throw DatabaseException('Failed to load vehicles: $e');
    }
  }

  Future<List<Vehicle>> search(String query, {required bool archived}) async {
    try {
      final String pattern = '%${query.trim().toLowerCase()}%';
      final results = await (_db.select(_db.vehicles).join([
            innerJoin(
              _db.customers,
              _db.customers.id.equalsExp(_db.vehicles.customerId),
            ),
          ])
            ..where(
              _db.vehicles.isArchived.equals(archived) &
                  (_db.vehicles.registrationNumber.lower().like(pattern) |
                      _db.vehicles.make.lower().like(pattern) |
                      _db.vehicles.model.lower().like(pattern) |
                      (_db.vehicles.engineNumber.isNotNull() &
                          _db.vehicles.engineNumber.lower().like(pattern)) |
                      _db.customers.fullName.lower().like(pattern)),
            )
            ..orderBy([OrderingTerm.asc(_db.vehicles.make)]))
          .get();
      return _mapJoined(results);
    } catch (e) {
      throw DatabaseException('Failed to search vehicles: $e');
    }
  }

  Stream<List<Vehicle>> watchAll({required bool archived}) {
    return _selectWithOwner(archived: archived).watch().map((rows) {
      return rows.map((row) {
        final VehicleRow vehicle = row.readTable(_db.vehicles);
        final CustomerRow customer = row.readTable(_db.customers);
        return _toEntity(vehicle, ownerName: customer.fullName);
      }).toList();
    });
  }

  Stream<List<Vehicle>> watchByCustomer(String customerId) {
    final query = _db.select(_db.vehicles).join([
      innerJoin(
        _db.customers,
        _db.customers.id.equalsExp(_db.vehicles.customerId),
      ),
    ])
      ..where(
        _db.vehicles.customerId.equals(customerId) &
            _db.vehicles.isArchived.equals(false),
      )
      ..orderBy([OrderingTerm.desc(_db.vehicles.updatedAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final VehicleRow vehicle = row.readTable(_db.vehicles);
        final CustomerRow customer = row.readTable(_db.customers);
        return _toEntity(vehicle, ownerName: customer.fullName);
      }).toList();
    });
  }

  Future<bool> isRegistrationTaken(
    String registrationNumber, {
    String? excludeId,
  }) async {
    try {
      final String normalized = registrationNumber.trim().toUpperCase();
      final query = _db.select(_db.vehicles)
        ..where(
          (t) => t.registrationNumber.upper().equals(normalized),
        );
      if (excludeId != null) {
        query.where((t) => t.id.equals(excludeId).not());
      }
      final VehicleRow? existing = await query.getSingleOrNull();
      return existing != null;
    } catch (e) {
      throw DatabaseException('Failed to check registration number: $e');
    }
  }

  Future<int> countActive() async {
    try {
      final countExp = _db.vehicles.id.count();
      final query = _db.selectOnly(_db.vehicles)
        ..addColumns([countExp])
        ..where(_db.vehicles.isArchived.equals(false));
      final result = await query.getSingle();
      return result.read(countExp) ?? 0;
    } catch (e) {
      throw DatabaseException('Failed to count vehicles: $e');
    }
  }

  Future<int> countByCustomer(String customerId) async {
    try {
      final countExp = _db.vehicles.id.count();
      final query = _db.selectOnly(_db.vehicles)
        ..addColumns([countExp])
        ..where(
          _db.vehicles.customerId.equals(customerId) &
              _db.vehicles.isArchived.equals(false),
        );
      final result = await query.getSingle();
      return result.read(countExp) ?? 0;
    } catch (e) {
      throw DatabaseException('Failed to count customer vehicles: $e');
    }
  }
}
