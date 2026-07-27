import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/user_profile.dart';

class UserProfileLocalDataSource {
  UserProfileLocalDataSource(this._db);

  final AppDatabase _db;

  UserProfile _map(UserProfileRow row) {
    return UserProfile(
      uid: row.uid,
      schemaVersion: row.schemaVersion,
      accountStatus: row.accountStatus,
      email: row.email,
      displayName: row.displayName,
      phone: row.phone,
      workshopName: row.workshopName,
      workshopTagline: row.workshopTagline,
      workshopAddress: row.workshopAddress,
      workshopPhone: row.workshopPhone,
      workshopEmail: row.workshopEmail,
      workshopLogoUrl: row.workshopLogoUrl,
      countryCode: row.countryCode,
      timezone: row.timezone,
      invoiceTaxPercent: row.invoiceTaxPercent,
      invoiceCurrency: row.invoiceCurrency,
      invoiceCurrencySymbol: row.invoiceCurrencySymbol,
      invoicePrefix: row.invoicePrefix,
      invoiceNextNumber: row.invoiceNextNumber,
      themeMode: row.themeMode,
      language: row.language,
      notificationsEnabled: row.notificationsEnabled,
      dailyReminderHour: row.dailyReminderHour,
      dailyReminderMinute: row.dailyReminderMinute,
      weeklySummaryEnabled: row.weeklySummaryEnabled,
      monthlySummaryEnabled: row.monthlySummaryEnabled,
      whatsappShortcutEnabled: row.whatsappShortcutEnabled,
      defaultMessageTemplateId: row.defaultMessageTemplateId,
      extraJson: row.extraJson,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  UserProfilesCompanion _companion(UserProfile profile) {
    return UserProfilesCompanion(
      uid: Value(profile.uid),
      schemaVersion: Value(profile.schemaVersion),
      accountStatus: Value(profile.accountStatus),
      email: Value(profile.email),
      displayName: Value(profile.displayName),
      phone: Value(profile.phone),
      workshopName: Value(profile.workshopName),
      workshopTagline: Value(profile.workshopTagline),
      workshopAddress: Value(profile.workshopAddress),
      workshopPhone: Value(profile.workshopPhone),
      workshopEmail: Value(profile.workshopEmail),
      workshopLogoUrl: Value(profile.workshopLogoUrl),
      countryCode: Value(profile.countryCode),
      timezone: Value(profile.timezone),
      invoiceTaxPercent: Value(profile.invoiceTaxPercent),
      invoiceCurrency: Value(profile.invoiceCurrency),
      invoiceCurrencySymbol: Value(profile.invoiceCurrencySymbol),
      invoicePrefix: Value(profile.invoicePrefix),
      invoiceNextNumber: Value(profile.invoiceNextNumber),
      themeMode: Value(profile.themeMode),
      language: Value(profile.language),
      notificationsEnabled: Value(profile.notificationsEnabled),
      dailyReminderHour: Value(profile.dailyReminderHour),
      dailyReminderMinute: Value(profile.dailyReminderMinute),
      weeklySummaryEnabled: Value(profile.weeklySummaryEnabled),
      monthlySummaryEnabled: Value(profile.monthlySummaryEnabled),
      whatsappShortcutEnabled: Value(profile.whatsappShortcutEnabled),
      defaultMessageTemplateId: Value(profile.defaultMessageTemplateId),
      extraJson: Value(profile.extraJson),
      createdAt: Value(profile.createdAt),
      updatedAt: Value(profile.updatedAt),
    );
  }

  Future<UserProfile?> getByUid(String uid) async {
    final row = await (_db.select(_db.userProfiles)
          ..where((t) => t.uid.equals(uid)))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Future<UserProfile> upsert(UserProfile profile) async {
    await _db.into(_db.userProfiles).insertOnConflictUpdate(_companion(profile));
    return profile;
  }
}
