/// Central registry of local DB and cloud document schema versions.
///
/// Bump [UserProfileSchema.version] when adding/removing user profile fields.
/// Bump [AppDatabase.schemaVersion] in app_database.dart when changing Drift tables.
abstract final class SchemaRegistry {
  static const int localDatabaseVersion = 12;

  static const String firestoreUserRoot = 'users';
  static const String firestoreProfileDoc = 'profile'; // reserved for future split

  /// All synced entity collections under `users/{uid}/`.
  static const List<String> syncedCollections = [
    'customers',
    'vehicles',
    'service_records',
    'maintenance_reminders',
    'invoices',
    'inventory_items',
    'message_templates',
    'maintenance_logs',
    'reminder_history',
  ];
}

/// Version history for `users/{uid}` profile document + local user_profiles row.
abstract final class UserProfileSchema {
  static const int version = 1;

  /// v1 fields (current):
  /// uid, email, displayName, phone,
  /// workshopName, workshopTagline, workshopAddress, workshopPhone,
  /// workshopEmail, workshopLogoUrl, countryCode, timezone,
  /// invoiceTaxPercent, invoiceCurrency, invoiceCurrencySymbol,
  /// invoicePrefix, invoiceNextNumber,
  /// themeMode, language,
  /// notificationsEnabled, dailyReminderHour, dailyReminderMinute,
  /// weeklySummaryEnabled, monthlySummaryEnabled, whatsappShortcutEnabled,
  /// defaultMessageTemplateId,
  /// accountStatus, schemaVersion, extraJson,
  /// createdAt, updatedAt, ownerUid, syncedAt (cloud only)
  static const List<String> v1Fields = [
    'uid',
    'email',
    'displayName',
    'phone',
    'workshopName',
    'workshopTagline',
    'workshopAddress',
    'workshopPhone',
    'workshopEmail',
    'workshopLogoUrl',
    'countryCode',
    'timezone',
    'invoiceTaxPercent',
    'invoiceCurrency',
    'invoiceCurrencySymbol',
    'invoicePrefix',
    'invoiceNextNumber',
    'themeMode',
    'language',
    'notificationsEnabled',
    'dailyReminderHour',
    'dailyReminderMinute',
    'weeklySummaryEnabled',
    'monthlySummaryEnabled',
    'whatsappShortcutEnabled',
    'defaultMessageTemplateId',
    'accountStatus',
    'schemaVersion',
    'extraJson',
    'createdAt',
    'updatedAt',
  ];
}

/// Standard audit columns present on all synced business entities.
abstract final class EntityAuditFields {
  static const List<String> required = ['id', 'createdAt', 'updatedAt'];

  static const List<String> cloudOnly = ['ownerUid', 'syncedAt'];
}

/// Account lifecycle states stored on user profile.
abstract final class AccountStatus {
  static const String active = 'active';
  static const String suspended = 'suspended';
  static const String pendingSetup = 'pending_setup';
}
