import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../utils/logger.dart';
import '../../features/settings/data/repositories/user_profile_repository.dart';
import '../../features/settings/domain/entities/user_profile.dart';
import 'auth_preferences.dart';

/// Reads/writes workshop profile and settings via SQLite + Firestore sync.
class SettingsService {
  SettingsService({
    required UserProfileRepository repository,
    required AuthPreferences authPreferences,
  })  : _repository = repository,
        _authPreferences = authPreferences;

  final UserProfileRepository _repository;
  final AuthPreferences _authPreferences;

  UserProfile? _profile;
  bool _legacyMigrated = false;

  UserProfile get _active =>
      _profile ??
      UserProfile.defaults(uid: 'local', email: '');

  bool get isLoaded => _profile != null;

  Future<void> loadForUser({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    await _authPreferences.setActiveUid(uid);
    await _authPreferences.setLastLoginEmail(email);

    UserProfile profile = await _repository.getOrCreate(
      uid: uid,
      email: email,
      displayName: displayName,
    );

    if (!_legacyMigrated) {
      profile = await _migrateLegacyPreferences(profile);
      _legacyMigrated = true;
      profile = await _repository.save(profile);
    }

    _profile = await _repository.ensureSynced(
      uid: uid,
      email: email,
      displayName: displayName,
    );
  }

  Future<void> clearUser() async {
    _profile = null;
    await _authPreferences.setActiveUid(null);
  }

  Future<UserProfile?> profileForUid(String uid) {
    return _repository.getByUid(uid);
  }

  Future<void> _persist(UserProfile Function(UserProfile current) update) async {
    if (_profile == null) {
      AppLogger.warning('SettingsService: no active profile — change ignored');
      return;
    }
    _profile = await _repository.save(update(_profile!));
  }

  Future<UserProfile> _migrateLegacyPreferences(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasLegacy = prefs.containsKey(AppConstants.themeModeKey) ||
        prefs.containsKey(AppConstants.userNameKey) ||
        prefs.containsKey(AppConstants.workshopDisplayNameKey);
    if (!hasLegacy) return profile;

    final migrated = profile.copyWith(
      displayName: prefs.getString(AppConstants.userNameKey) ?? profile.displayName,
      phone: prefs.getString(AppConstants.userPhoneKey),
      workshopName: prefs.getString(AppConstants.workshopDisplayNameKey) ??
          profile.workshopName,
      workshopAddress: prefs.getString(AppConstants.workshopAddressKey),
      workshopPhone: prefs.getString(AppConstants.workshopPhoneKey),
      invoiceTaxPercent:
          prefs.getDouble(AppConstants.invoiceTaxPercentKey) ?? profile.invoiceTaxPercent,
      invoiceCurrency:
          prefs.getString(AppConstants.invoiceCurrencyKey) ?? profile.invoiceCurrency,
      invoiceCurrencySymbol: prefs.getString(AppConstants.invoiceCurrencySymbolKey) ??
          profile.invoiceCurrencySymbol,
      invoicePrefix:
          prefs.getString(AppConstants.invoicePrefixKey) ?? profile.invoicePrefix,
      invoiceNextNumber:
          prefs.getInt(AppConstants.invoiceNextNumberKey) ?? profile.invoiceNextNumber,
      themeMode: prefs.getString(AppConstants.themeModeKey) ?? profile.themeMode,
      language: prefs.getString(AppConstants.languageKey) ?? profile.language,
      notificationsEnabled:
          prefs.getBool(AppConstants.notificationsEnabledKey) ??
              profile.notificationsEnabled,
      dailyReminderHour:
          prefs.getInt(AppConstants.dailyReminderHourKey) ?? profile.dailyReminderHour,
      dailyReminderMinute:
          prefs.getInt(AppConstants.dailyReminderMinuteKey) ??
              profile.dailyReminderMinute,
      weeklySummaryEnabled:
          prefs.getBool(AppConstants.weeklySummaryEnabledKey) ??
              profile.weeklySummaryEnabled,
      monthlySummaryEnabled:
          prefs.getBool(AppConstants.monthlySummaryEnabledKey) ??
              profile.monthlySummaryEnabled,
      whatsappShortcutEnabled:
          prefs.getBool(AppConstants.whatsappShortcutEnabledKey) ??
              profile.whatsappShortcutEnabled,
      defaultMessageTemplateId:
          prefs.getString(AppConstants.defaultMessageTemplateIdKey),
      updatedAt: DateTime.now().toUtc(),
    );

    for (final key in [
      AppConstants.themeModeKey,
      AppConstants.languageKey,
      AppConstants.notificationsEnabledKey,
      AppConstants.dailyReminderHourKey,
      AppConstants.dailyReminderMinuteKey,
      AppConstants.weeklySummaryEnabledKey,
      AppConstants.monthlySummaryEnabledKey,
      AppConstants.whatsappShortcutEnabledKey,
      AppConstants.defaultMessageTemplateIdKey,
      AppConstants.workshopAddressKey,
      AppConstants.workshopPhoneKey,
      AppConstants.invoiceTaxPercentKey,
      AppConstants.invoiceCurrencyKey,
      AppConstants.invoiceCurrencySymbolKey,
      AppConstants.invoicePrefixKey,
      AppConstants.invoiceNextNumberKey,
      AppConstants.workshopDisplayNameKey,
      AppConstants.userNameKey,
      AppConstants.userEmailKey,
      AppConstants.userPhoneKey,
    ]) {
      await prefs.remove(key);
    }

    AppLogger.info('Migrated legacy SharedPreferences into user profile');
    return migrated;
  }

  // ── Theme ──────────────────────────────────────────────

  ThemeMode get themeMode => _active.themeModeValue;

  Future<void> setThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _persist((p) => p.copyWith(themeMode: value));
    AppLogger.info('Theme mode set to $value');
  }

  // ── Language ───────────────────────────────────────────

  String get language => _active.language;

  Future<void> setLanguage(String languageCode) async {
    await _persist((p) => p.copyWith(language: languageCode));
    AppLogger.info('Language set to $languageCode');
  }

  // ── Notifications ──────────────────────────────────────

  bool get notificationsEnabled => _active.notificationsEnabled;

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _persist((p) => p.copyWith(notificationsEnabled: enabled));
    AppLogger.info('Notifications enabled: $enabled');
  }

  int get dailyReminderHour => _active.dailyReminderHour;

  int get dailyReminderMinute => _active.dailyReminderMinute;

  Future<void> setDailyReminderTime({
    required int hour,
    required int minute,
  }) async {
    await _persist(
      (p) => p.copyWith(
        dailyReminderHour: hour,
        dailyReminderMinute: minute,
      ),
    );
    AppLogger.info('Daily reminder time set to $hour:$minute');
  }

  bool get weeklySummaryEnabled => _active.weeklySummaryEnabled;

  Future<void> setWeeklySummaryEnabled(bool enabled) async {
    await _persist((p) => p.copyWith(weeklySummaryEnabled: enabled));
  }

  bool get monthlySummaryEnabled => _active.monthlySummaryEnabled;

  Future<void> setMonthlySummaryEnabled(bool enabled) async {
    await _persist((p) => p.copyWith(monthlySummaryEnabled: enabled));
  }

  bool get whatsappShortcutEnabled => _active.whatsappShortcutEnabled;

  Future<void> setWhatsappShortcutEnabled(bool enabled) async {
    await _persist((p) => p.copyWith(whatsappShortcutEnabled: enabled));
  }

  String? get defaultMessageTemplateId => _active.defaultMessageTemplateId;

  Future<void> setDefaultMessageTemplateId(String? id) async {
    await _persist(
      (p) => p.copyWith(
        defaultMessageTemplateId: id,
        clearDefaultMessageTemplateId: id == null,
      ),
    );
  }

  // ── Invoice / workshop ─────────────────────────────────

  String get workshopDisplayName => _active.workshopName;

  Future<void> setWorkshopDisplayName(String name) async {
    await _persist((p) => p.copyWith(workshopName: name));
  }

  String get workshopAddress => _active.workshopAddress ?? '';

  Future<void> setWorkshopAddress(String value) async {
    await _persist((p) => p.copyWith(workshopAddress: value));
  }

  String get workshopPhone => _active.workshopPhone ?? '';

  Future<void> setWorkshopPhone(String value) async {
    await _persist((p) => p.copyWith(workshopPhone: value));
  }

  double get invoiceTaxPercent => _active.invoiceTaxPercent;

  Future<void> setInvoiceTaxPercent(double value) async {
    await _persist((p) => p.copyWith(invoiceTaxPercent: value));
  }

  String get invoiceCurrency => _active.invoiceCurrency;

  Future<void> setInvoiceCurrency(String value) async {
    await _persist((p) => p.copyWith(invoiceCurrency: value));
  }

  String get invoiceCurrencySymbol => _active.invoiceCurrencySymbol;

  Future<void> setInvoiceCurrencySymbol(String value) async {
    await _persist((p) => p.copyWith(invoiceCurrencySymbol: value));
  }

  String get invoicePrefix => _active.invoicePrefix;

  Future<void> setInvoicePrefix(String value) async {
    await _persist((p) => p.copyWith(invoicePrefix: value));
  }

  int get invoiceNextNumber => _active.invoiceNextNumber;

  Future<void> setInvoiceNextNumber(int value) async {
    await _persist((p) => p.copyWith(invoiceNextNumber: value));
  }

  Future<String> allocateInvoiceNumber() async {
    final int n = invoiceNextNumber;
    final String number = '$invoicePrefix-${n.toString().padLeft(5, '0')}';
    await setInvoiceNextNumber(n + 1);
    return number;
  }

  // ── User profile ───────────────────────────────────────

  String get userName => _active.displayName;

  Future<void> setUserName(String value) async {
    await _persist((p) => p.copyWith(displayName: value));
  }

  String get userEmail => _active.email;

  Future<void> setUserEmail(String value) async {
    await _persist((p) => p.copyWith(email: value));
  }

  String get userPhone => _active.phone ?? '';

  Future<void> setUserPhone(String value) async {
    await _persist((p) => p.copyWith(phone: value));
  }

  String? get lastLoginEmail => _authPreferences.lastLoginEmail;

  String? get activeUid => _authPreferences.activeUid;
}
