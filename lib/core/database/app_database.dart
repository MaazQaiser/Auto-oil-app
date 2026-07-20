import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/customers_table.dart';
import 'tables/inventory_items_table.dart';
import 'tables/invoices_table.dart';
import 'tables/maintenance_logs_table.dart';
import 'tables/maintenance_reminders_table.dart';
import 'tables/message_templates_table.dart';
import 'tables/reminder_history_table.dart';
import 'tables/service_records_table.dart';
import 'tables/sync_meta_table.dart';
import 'tables/sync_outbox_table.dart';
import 'tables/vehicles_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Customers,
    Vehicles,
    ServiceRecords,
    MaintenanceReminders,
    MessageTemplates,
    ReminderHistory,
    Invoices,
    InventoryItems,
    MaintenanceLogs,
    SyncOutbox,
    SyncMeta,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(customers);
        }
        if (from < 3) {
          await m.createTable(vehicles);
        }
        if (from < 4) {
          await m.createTable(serviceRecords);
        }
        if (from < 5) {
          await m.createTable(maintenanceReminders);
        }
        if (from < 6) {
          await m.createTable(messageTemplates);
          await m.createTable(reminderHistory);
        }
        if (from < 7) {
          await m.createTable(invoices);
        }
        if (from < 8) {
          await m.createTable(inventoryItems);
        }
        if (from < 9) {
          await m.createTable(maintenanceLogs);
        }
        if (from < 10) {
          await m.createTable(syncOutbox);
          await m.createTable(syncMeta);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'autocare_manager',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  Future<void> disposeDb() => close();
}
