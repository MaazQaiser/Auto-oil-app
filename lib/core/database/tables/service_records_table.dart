import 'package:drift/drift.dart';

import 'vehicles_table.dart';

/// Service / maintenance visit records attached to a vehicle.
@TableIndex(name: 'idx_service_records_vehicle', columns: {#vehicleId})
@TableIndex(name: 'idx_service_records_date', columns: {#serviceDate})
@DataClassName('ServiceRecordRow')
class ServiceRecords extends Table {
  TextColumn get id => text()();

  TextColumn get vehicleId => text().references(Vehicles, #id)();

  DateTimeColumn get serviceDate => dateTime()();

  IntColumn get odometerReading => integer()();

  TextColumn get serviceType => text()();

  TextColumn get description => text().nullable()();

  TextColumn get oilBrand => text().nullable()();

  RealColumn get laborCost => real().withDefault(const Constant(0.0))();

  RealColumn get partsCost => real().withDefault(const Constant(0.0))();

  RealColumn get totalCost => real().withDefault(const Constant(0.0))();

  TextColumn get notes => text().nullable()();

  /// km | date | both — used when creating/updating the linked reminder.
  TextColumn get reminderType => text().nullable()();

  IntColumn get nextServiceOdometer => integer().nullable()();

  DateTimeColumn get nextServiceDate => dateTime().nullable()();

  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get whatsappEnabled =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
