import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../config/app_config.dart';
import '../utils/logger.dart';

/// Persists user preferences (theme, language, notifications).
class SettingsService {
  SettingsService(this._prefs);

  final SharedPreferences _prefs;

  static Future<SettingsService> create() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return SettingsService(prefs);
  }

  // ── Theme ──────────────────────────────────────────────

  ThemeMode get themeMode {
    final String? value = _prefs.getString(AppConstants.themeModeKey);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final String value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(AppConstants.themeModeKey, value);
    AppLogger.info('Theme mode set to $value');
  }

  // ── Language ───────────────────────────────────────────

  String get language =>
      _prefs.getString(AppConstants.languageKey) ?? AppConfig.defaultLanguage;

  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(AppConstants.languageKey, languageCode);
    AppLogger.info('Language set to $languageCode');
  }

  // ── Notifications ──────────────────────────────────────

  bool get notificationsEnabled =>
      _prefs.getBool(AppConstants.notificationsEnabledKey) ?? true;

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.notificationsEnabledKey, enabled);
    AppLogger.info('Notifications enabled: $enabled');
  }

  int get dailyReminderHour =>
      _prefs.getInt(AppConstants.dailyReminderHourKey) ?? 8;

  int get dailyReminderMinute =>
      _prefs.getInt(AppConstants.dailyReminderMinuteKey) ?? 0;

  Future<void> setDailyReminderTime({
    required int hour,
    required int minute,
  }) async {
    await _prefs.setInt(AppConstants.dailyReminderHourKey, hour);
    await _prefs.setInt(AppConstants.dailyReminderMinuteKey, minute);
    AppLogger.info('Daily reminder time set to $hour:$minute');
  }

  bool get weeklySummaryEnabled =>
      _prefs.getBool(AppConstants.weeklySummaryEnabledKey) ?? true;

  Future<void> setWeeklySummaryEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.weeklySummaryEnabledKey, enabled);
  }

  bool get monthlySummaryEnabled =>
      _prefs.getBool(AppConstants.monthlySummaryEnabledKey) ?? true;

  Future<void> setMonthlySummaryEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.monthlySummaryEnabledKey, enabled);
  }

  bool get whatsappShortcutEnabled =>
      _prefs.getBool(AppConstants.whatsappShortcutEnabledKey) ?? true;

  Future<void> setWhatsappShortcutEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.whatsappShortcutEnabledKey, enabled);
  }

  String? get defaultMessageTemplateId =>
      _prefs.getString(AppConstants.defaultMessageTemplateIdKey);

  Future<void> setDefaultMessageTemplateId(String? id) async {
    if (id == null) {
      await _prefs.remove(AppConstants.defaultMessageTemplateIdKey);
    } else {
      await _prefs.setString(AppConstants.defaultMessageTemplateIdKey, id);
    }
  }

  // ── Invoice / workshop ─────────────────────────────────

  String get workshopDisplayName =>
      _prefs.getString(AppConstants.workshopDisplayNameKey) ??
      AppConfig.workshopName;

  Future<void> setWorkshopDisplayName(String name) async {
    await _prefs.setString(AppConstants.workshopDisplayNameKey, name);
  }

  String get workshopAddress =>
      _prefs.getString(AppConstants.workshopAddressKey) ?? '';

  Future<void> setWorkshopAddress(String value) async {
    await _prefs.setString(AppConstants.workshopAddressKey, value);
  }

  String get workshopPhone =>
      _prefs.getString(AppConstants.workshopPhoneKey) ?? '';

  Future<void> setWorkshopPhone(String value) async {
    await _prefs.setString(AppConstants.workshopPhoneKey, value);
  }

  double get invoiceTaxPercent =>
      _prefs.getDouble(AppConstants.invoiceTaxPercentKey) ?? 0;

  Future<void> setInvoiceTaxPercent(double value) async {
    await _prefs.setDouble(AppConstants.invoiceTaxPercentKey, value);
  }

  String get invoiceCurrency =>
      _prefs.getString(AppConstants.invoiceCurrencyKey) ??
      AppConstants.defaultCurrencyCode;

  Future<void> setInvoiceCurrency(String value) async {
    await _prefs.setString(AppConstants.invoiceCurrencyKey, value);
  }

  String get invoiceCurrencySymbol =>
      _prefs.getString(AppConstants.invoiceCurrencySymbolKey) ??
      AppConstants.defaultCurrencySymbol;

  Future<void> setInvoiceCurrencySymbol(String value) async {
    await _prefs.setString(AppConstants.invoiceCurrencySymbolKey, value);
  }

  String get invoicePrefix =>
      _prefs.getString(AppConstants.invoicePrefixKey) ?? 'INV';

  Future<void> setInvoicePrefix(String value) async {
    await _prefs.setString(AppConstants.invoicePrefixKey, value);
  }

  int get invoiceNextNumber =>
      _prefs.getInt(AppConstants.invoiceNextNumberKey) ?? 1;

  Future<void> setInvoiceNextNumber(int value) async {
    await _prefs.setInt(AppConstants.invoiceNextNumberKey, value);
  }

  Future<String> allocateInvoiceNumber() async {
    final int n = invoiceNextNumber;
    final String number = '$invoicePrefix-${n.toString().padLeft(5, '0')}';
    await setInvoiceNextNumber(n + 1);
    return number;
  }

  // ── User profile ───────────────────────────────────────

  String get userName => _prefs.getString(AppConstants.userNameKey) ?? 'Owner';

  Future<void> setUserName(String value) async {
    await _prefs.setString(AppConstants.userNameKey, value);
  }

  String get userEmail => _prefs.getString(AppConstants.userEmailKey) ?? '';

  Future<void> setUserEmail(String value) async {
    await _prefs.setString(AppConstants.userEmailKey, value);
  }

  String get userPhone => _prefs.getString(AppConstants.userPhoneKey) ?? '';

  Future<void> setUserPhone(String value) async {
    await _prefs.setString(AppConstants.userPhoneKey, value);
  }

  bool get hasPassword =>
      (_prefs.getString(AppConstants.userPasswordKey) ?? '').isNotEmpty;

  bool verifyPassword(String password) {
    final stored = _prefs.getString(AppConstants.userPasswordKey) ?? '';
    if (stored.isEmpty) return password.isEmpty;
    return stored == password;
  }

  Future<void> setPassword(String password) async {
    await _prefs.setString(AppConstants.userPasswordKey, password);
  }

  SharedPreferences get prefs => _prefs;
}
