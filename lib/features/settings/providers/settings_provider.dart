import 'package:autocare_manager/core/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the initialized [SettingsService].
final settingsServiceProvider = Provider<SettingsService>((ref) {
  throw UnimplementedError(
    'settingsServiceProvider must be overridden in ProviderScope',
  );
});

/// Persisted app settings state.
class AppSettings {
  const AppSettings({
    required this.themeMode,
    required this.language,
    required this.notificationsEnabled,
    required this.dailyReminderHour,
    required this.dailyReminderMinute,
    required this.weeklySummaryEnabled,
    required this.monthlySummaryEnabled,
    required this.whatsappShortcutEnabled,
  });

  final ThemeMode themeMode;
  final String language;
  final bool notificationsEnabled;
  final int dailyReminderHour;
  final int dailyReminderMinute;
  final bool weeklySummaryEnabled;
  final bool monthlySummaryEnabled;
  final bool whatsappShortcutEnabled;

  TimeOfDay get dailyReminderTime =>
      TimeOfDay(hour: dailyReminderHour, minute: dailyReminderMinute);

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? language,
    bool? notificationsEnabled,
    int? dailyReminderHour,
    int? dailyReminderMinute,
    bool? weeklySummaryEnabled,
    bool? monthlySummaryEnabled,
    bool? whatsappShortcutEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
      weeklySummaryEnabled:
          weeklySummaryEnabled ?? this.weeklySummaryEnabled,
      monthlySummaryEnabled:
          monthlySummaryEnabled ?? this.monthlySummaryEnabled,
      whatsappShortcutEnabled:
          whatsappShortcutEnabled ?? this.whatsappShortcutEnabled,
    );
  }
}

/// Notifier that syncs settings with [SettingsService].
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier(this._service)
      : super(
          AppSettings(
            themeMode: _service.themeMode,
            language: _service.language,
            notificationsEnabled: _service.notificationsEnabled,
            dailyReminderHour: _service.dailyReminderHour,
            dailyReminderMinute: _service.dailyReminderMinute,
            weeklySummaryEnabled: _service.weeklySummaryEnabled,
            monthlySummaryEnabled: _service.monthlySummaryEnabled,
            whatsappShortcutEnabled: _service.whatsappShortcutEnabled,
          ),
        );

  final SettingsService _service;

  Future<void> setThemeMode(ThemeMode mode) async {
    await _service.setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLanguage(String language) async {
    await _service.setLanguage(language);
    state = state.copyWith(language: language);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _service.setNotificationsEnabled(enabled);
    state = state.copyWith(notificationsEnabled: enabled);
  }

  Future<void> setDailyReminderTime(TimeOfDay time) async {
    await _service.setDailyReminderTime(
      hour: time.hour,
      minute: time.minute,
    );
    state = state.copyWith(
      dailyReminderHour: time.hour,
      dailyReminderMinute: time.minute,
    );
  }

  Future<void> setWeeklySummaryEnabled(bool enabled) async {
    await _service.setWeeklySummaryEnabled(enabled);
    state = state.copyWith(weeklySummaryEnabled: enabled);
  }

  Future<void> setMonthlySummaryEnabled(bool enabled) async {
    await _service.setMonthlySummaryEnabled(enabled);
    state = state.copyWith(monthlySummaryEnabled: enabled);
  }

  Future<void> setWhatsappShortcutEnabled(bool enabled) async {
    await _service.setWhatsappShortcutEnabled(enabled);
    state = state.copyWith(whatsappShortcutEnabled: enabled);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final SettingsService service = ref.watch(settingsServiceProvider);
  return SettingsNotifier(service);
});
