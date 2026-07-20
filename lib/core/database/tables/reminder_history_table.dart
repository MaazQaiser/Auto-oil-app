import 'package:drift/drift.dart';

/// Audit log for reminder / notification / WhatsApp actions.
@DataClassName('ReminderHistoryRow')
@TableIndex(name: 'idx_reminder_history_reminder', columns: {#reminderId})
@TableIndex(name: 'idx_reminder_history_created', columns: {#createdAt})
class ReminderHistory extends Table {
  TextColumn get id => text()();

  TextColumn get reminderId => text().nullable()();

  TextColumn get vehicleId => text().nullable()();

  TextColumn get customerId => text().nullable()();

  /// reminder_sent | notification_sent | whatsapp_opened | completed | dismissed
  TextColumn get actionType => text()();

  TextColumn get title => text().nullable()();

  TextColumn get details => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
