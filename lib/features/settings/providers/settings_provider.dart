import 'package:autocare_manager/core/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/sync/sync_providers.dart';
import '../../../shared/providers/database_provider.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../data/datasources/user_profile_local_datasource.dart';
import '../data/repositories/user_profile_repository.dart';

/// Provides the initialized [SettingsService].
final settingsServiceProvider = Provider<SettingsService>((ref) {
  throw UnimplementedError(
    'settingsServiceProvider must be overridden in ProviderScope',
  );
});

final userProfileLocalDataSourceProvider =
    Provider<UserProfileLocalDataSource>((ref) {
  return UserProfileLocalDataSource(ref.watch(databaseProvider));
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository(
    ref.watch(userProfileLocalDataSourceProvider),
    ref.watch(firestoreRemoteDataSourceProvider),
  );
});

/// Loads profile from SQLite + Firestore when auth state changes.
final userProfileBootstrapProvider = Provider<void>((ref) {
  final auth = ref.watch(authStateProvider);
  auth.whenData((user) async {
    final settings = ref.read(settingsServiceProvider);
    if (user != null) {
      await settings.loadForUser(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
      );
      ref.read(settingsProvider.notifier).reloadFromService();
    } else {
      await settings.clearUser();
      ref.read(settingsProvider.notifier).reloadFromService();
    }
  });
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
  SettingsNotifier(this._service) : super(_serviceToState(_service));

  final SettingsService _service;

  static AppSettings _serviceToState(SettingsService service) {
    return AppSettings(
      themeMode: service.themeMode,
      language: service.language,
      notificationsEnabled: service.notificationsEnabled,
      dailyReminderHour: service.dailyReminderHour,
      dailyReminderMinute: service.dailyReminderMinute,
      weeklySummaryEnabled: service.weeklySummaryEnabled,
      monthlySummaryEnabled: service.monthlySummaryEnabled,
      whatsappShortcutEnabled: service.whatsappShortcutEnabled,
    );
  }

  void reloadFromService() {
    state = _serviceToState(_service);
  }

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
