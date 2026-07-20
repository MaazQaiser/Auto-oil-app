import 'package:drift/drift.dart';

import 'service_records_table.dart';
import 'vehicles_table.dart';

/// Maintenance reminders derived from service records.
@TableIndex(name: 'idx_reminders_vehicle', columns: {#vehicleId})
@TableIndex(name: 'idx_reminders_service', columns: {#serviceRecordId})
@TableIndex(name: 'idx_reminders_status', columns: {#status})
@TableIndex(name: 'idx_reminders_next_date', columns: {#nextServiceDate})
@DataClassName('MaintenanceReminderRow')
class MaintenanceReminders extends Table {
  TextColumn get id => text()();

  TextColumn get vehicleId => text().references(Vehicles, #id)();

  TextColumn get serviceRecordId =>
      text().references(ServiceRecords, #id)();

  IntColumn get currentOdometer => integer()();

  IntColumn get nextServiceOdometer => integer().nullable()();

  DateTimeColumn get lastServiceDate => dateTime()();

  DateTimeColumn get nextServiceDate => dateTime().nullable()();

  /// km | date | both
  TextColumn get reminderType => text()();

  /// upcoming | due | overdue | completed
  TextColumn get status => text()();

  DateTimeColumn get lastReminderSent => dateTime().nullable()();

  BoolColumn get notificationEnabled =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get whatsappEnabled =>
      boolean().withDefault(const Constant(false))();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
