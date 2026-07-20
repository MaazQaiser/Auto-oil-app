import 'package:drift/drift.dart';

import 'vehicles_table.dart';

/// Timestamped maintenance notes for a vehicle.
@TableIndex(name: 'idx_maintenance_logs_vehicle', columns: {#vehicleId})
@DataClassName('MaintenanceLogRow')
class MaintenanceLogs extends Table {
  TextColumn get id => text()();

  TextColumn get vehicleId => text().references(Vehicles, #id)();

  TextColumn get note => text().withLength(min: 1, max: 2000)();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
