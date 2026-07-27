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
  static const String lastReconcileAt = 'last_reconcile_at';
  static const String syncCycleCount = 'sync_cycle_count';

  /// Per-collection ISO-8601 cursor for incremental pulls.
  static String pullCursor(String collection) => 'pull_cursor_$collection';
}

abstract final class SyncConfig {
  /// Foreground periodic sync while the app is running.
  static const Duration foregroundInterval = Duration(minutes: 2);

  /// Reconcile remote/local document IDs at most this often.
  static const Duration reconcileInterval = Duration(hours: 6);

  /// Force reconcile every N sync cycles regardless of time.
  static const int reconcileEveryNCycles = 15;

  /// Max outbox flush attempts before skipping until manual reset.
  static const int maxOutboxAttempts = 12;

  /// Overlap window subtracted from pull cursor to avoid clock skew misses.
  static const Duration pullOverlap = Duration(seconds: 30);
}
