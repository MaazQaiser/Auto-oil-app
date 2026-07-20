import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/service_record.dart';
import '../../../reminders/domain/entities/reminder_enums.dart';

class ServiceRecordLocalDataSource {
  ServiceRecordLocalDataSource(this._db);

  final AppDatabase _db;

  ServiceRecord _toEntity(ServiceRecordRow row, {String? vehicleName, String? reg, String? owner}) {
    return ServiceRecord(
      id: row.id,
      vehicleId: row.vehicleId,
      serviceDate: row.serviceDate,
      odometerReading: row.odometerReading,
      serviceType: row.serviceType,
      description: row.description,
      oilBrand: row.oilBrand,
      laborCost: row.laborCost,
      partsCost: row.partsCost,
      totalCost: row.totalCost,
      notes: row.notes,
      reminderType: row.reminderType == null
          ? null
          : ReminderType.fromStorage(row.reminderType!),
      nextServiceOdometer: row.nextServiceOdometer,
      nextServiceDate: row.nextServiceDate,
      reminderEnabled: row.reminderEnabled,
      whatsappEnabled: row.whatsappEnabled,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isArchived: row.isArchived,
      vehicleDisplayName: vehicleName,
      registrationNumber: reg,
      ownerName: owner,
    );
  }

  ServiceRecordsCompanion _toCompanion(ServiceRecord record) {
    return ServiceRecordsCompanion(
      id: Value(record.id),
      vehicleId: Value(record.vehicleId),
      serviceDate: Value(record.serviceDate),
      odometerReading: Value(record.odometerReading),
      serviceType: Value(record.serviceType),
      description: Value(record.description),
      oilBrand: Value(record.oilBrand),
      laborCost: Value(record.laborCost),
      partsCost: Value(record.partsCost),
      totalCost: Value(record.totalCost),
      notes: Value(record.notes),
      reminderType: Value(record.reminderType?.name),
      nextServiceOdometer: Value(record.nextServiceOdometer),
      nextServiceDate: Value(record.nextServiceDate),
      reminderEnabled: Value(record.reminderEnabled),
      whatsappEnabled: Value(record.whatsappEnabled),
      createdAt: Value(record.createdAt),
      updatedAt: Value(record.updatedAt),
      isArchived: Value(record.isArchived),
    );
  }

  Future<ServiceRecord> insert(ServiceRecord record) async {
    try {
      await _db.into(_db.serviceRecords).insert(_toCompanion(record));
      // Bump vehicle odo if higher.
      final vehicle = await (_db.select(_db.vehicles)
            ..where((t) => t.id.equals(record.vehicleId)))
          .getSingleOrNull();
      if (vehicle != null && record.odometerReading > vehicle.currentOdo) {
        await (_db.update(_db.vehicles)
              ..where((t) => t.id.equals(record.vehicleId)))
            .write(
          VehiclesCompanion(
            currentOdo: Value(record.odometerReading),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
      return (await getById(record.id)) ?? record;
    } catch (e) {
      throw DatabaseException('Failed to create service record: $e');
    }
  }

  Future<ServiceRecord> update(ServiceRecord record) async {
    try {
      final int n = await (_db.update(_db.serviceRecords)
            ..where((t) => t.id.equals(record.id)))
          .write(_toCompanion(record));
      if (n == 0) throw const NotFoundException('Service record not found');
      return (await getById(record.id)) ?? record;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to update service record: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      final int n = await (_db.delete(_db.serviceRecords)
            ..where((t) => t.id.equals(id)))
          .go();
      if (n == 0) throw const NotFoundException('Service record not found');
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to delete service record: $e');
    }
  }

  Future<ServiceRecord?> getById(String id) async {
    try {
      final query = _db.select(_db.serviceRecords).join([
        innerJoin(
          _db.vehicles,
          _db.vehicles.id.equalsExp(_db.serviceRecords.vehicleId),
        ),
        innerJoin(
          _db.customers,
          _db.customers.id.equalsExp(_db.vehicles.customerId),
        ),
      ])
        ..where(_db.serviceRecords.id.equals(id));
      final row = await query.getSingleOrNull();
      if (row == null) return null;
      final sr = row.readTable(_db.serviceRecords);
      final v = row.readTable(_db.vehicles);
      final c = row.readTable(_db.customers);
      return _toEntity(
        sr,
        vehicleName: '${v.make} ${v.model}',
        reg: v.registrationNumber,
        owner: c.fullName,
      );
    } catch (e) {
      throw DatabaseException('Failed to get service record: $e');
    }
  }

  Future<List<ServiceRecord>> getByVehicle(String vehicleId) async {
    try {
      final query = _db.select(_db.serviceRecords).join([
        innerJoin(
          _db.vehicles,
          _db.vehicles.id.equalsExp(_db.serviceRecords.vehicleId),
        ),
        innerJoin(
          _db.customers,
          _db.customers.id.equalsExp(_db.vehicles.customerId),
        ),
      ])
        ..where(
          _db.serviceRecords.vehicleId.equals(vehicleId) &
              _db.serviceRecords.isArchived.equals(false),
        )
        ..orderBy([OrderingTerm.desc(_db.serviceRecords.serviceDate)]);
      final rows = await query.get();
      return rows.map((row) {
        final sr = row.readTable(_db.serviceRecords);
        final v = row.readTable(_db.vehicles);
        final c = row.readTable(_db.customers);
        return _toEntity(
          sr,
          vehicleName: '${v.make} ${v.model}',
          reg: v.registrationNumber,
          owner: c.fullName,
        );
      }).toList();
    } catch (e) {
      throw DatabaseException('Failed to load service records: $e');
    }
  }

  Stream<List<ServiceRecord>> watchByVehicle(String vehicleId) {
    final query = _db.select(_db.serviceRecords).join([
      innerJoin(
        _db.vehicles,
        _db.vehicles.id.equalsExp(_db.serviceRecords.vehicleId),
      ),
      innerJoin(
        _db.customers,
        _db.customers.id.equalsExp(_db.vehicles.customerId),
      ),
    ])
      ..where(
        _db.serviceRecords.vehicleId.equals(vehicleId) &
            _db.serviceRecords.isArchived.equals(false),
      )
      ..orderBy([OrderingTerm.desc(_db.serviceRecords.serviceDate)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final sr = row.readTable(_db.serviceRecords);
        final v = row.readTable(_db.vehicles);
        final c = row.readTable(_db.customers);
        return _toEntity(
          sr,
          vehicleName: '${v.make} ${v.model}',
          reg: v.registrationNumber,
          owner: c.fullName,
        );
      }).toList();
    });
  }

  Future<double> totalRevenue() async {
    try {
      final sumExp = _db.serviceRecords.totalCost.sum();
      final query = _db.selectOnly(_db.serviceRecords)
        ..addColumns([sumExp])
        ..where(_db.serviceRecords.isArchived.equals(false));
      final row = await query.getSingle();
      return row.read(sumExp) ?? 0;
    } catch (e) {
      throw DatabaseException('Failed to sum revenue: $e');
    }
  }
}
