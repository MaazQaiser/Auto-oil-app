import 'package:drift/drift.dart';

import '../schema_registry.dart';

/// Workshop owner profile and app settings — one row per Firebase uid.
@DataClassName('UserProfileRow')
class UserProfiles extends Table {
  TextColumn get uid => text()();

  /// Profile document schema version — see [UserProfileSchema.version].
  IntColumn get schemaVersion =>
      integer().withDefault(const Constant(UserProfileSchema.version))();

  /// active | suspended | pending_setup
  TextColumn get accountStatus =>
      text().withDefault(const Constant(AccountStatus.active))();

  TextColumn get email => text()();

  TextColumn get displayName => text().withDefault(const Constant('Owner'))();

  TextColumn get phone => text().nullable()();

  TextColumn get workshopName =>
      text().withDefault(const Constant('Muzammil Autos'))();

  TextColumn get workshopTagline => text().nullable()();

  TextColumn get workshopAddress => text().nullable()();

  TextColumn get workshopPhone => text().nullable()();

  TextColumn get workshopEmail => text().nullable()();

  /// Remote URL or local asset path for workshop branding.
  TextColumn get workshopLogoUrl => text().nullable()();

  /// ISO 3166-1 alpha-2, e.g. PK, US.
  TextColumn get countryCode => text().nullable()();

  /// IANA timezone, e.g. Asia/Karachi — used for reminders and reports.
  TextColumn get timezone => text().withDefault(const Constant('Asia/Karachi'))();

  RealColumn get invoiceTaxPercent => real().withDefault(const Constant(0.0))();

  TextColumn get invoiceCurrency =>
      text().withDefault(const Constant('USD'))();

  TextColumn get invoiceCurrencySymbol =>
      text().withDefault(const Constant('\$'))();

  TextColumn get invoicePrefix =>
      text().withDefault(const Constant('INV'))();

  IntColumn get invoiceNextNumber => integer().withDefault(const Constant(1))();

  /// light | dark | system
  TextColumn get themeMode => text().withDefault(const Constant('system'))();

  TextColumn get language => text().withDefault(const Constant('en'))();

  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();

  IntColumn get dailyReminderHour => integer().withDefault(const Constant(8))();

  IntColumn get dailyReminderMinute =>
      integer().withDefault(const Constant(0))();

  BoolColumn get weeklySummaryEnabled =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get monthlySummaryEnabled =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get whatsappShortcutEnabled =>
      boolean().withDefault(const Constant(true))();

  TextColumn get defaultMessageTemplateId => text().nullable()();

  /// Forward-compatible JSON blob for fields not yet in the typed schema.
  TextColumn get extraJson => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {uid};
}
