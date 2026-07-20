/// Firestore subcollection names under `users/{uid}/…`.
abstract final class SyncCollections {
  static const String customers = 'customers';
  static const String vehicles = 'vehicles';
  static const String serviceRecords = 'service_records';
  static const String maintenanceReminders = 'maintenance_reminders';
  static const String invoices = 'invoices';
  static const String inventoryItems = 'inventory_items';
  static const String messageTemplates = 'message_templates';
  static const String maintenanceLogs = 'maintenance_logs';
  static const String reminderHistory = 'reminder_history';

  static const List<String> all = [
    customers,
    vehicles,
    serviceRecords,
    maintenanceReminders,
    invoices,
    inventoryItems,
    messageTemplates,
    maintenanceLogs,
    reminderHistory,
  ];
}

abstract final class SyncOperations {
  static const String upsert = 'upsert';
  static const String delete = 'delete';
}

abstract final class SyncMetaKeys {
  static const String lastSyncedAt = 'last_synced_at';
  static const String initialPushDone = 'initial_push_done';
}
