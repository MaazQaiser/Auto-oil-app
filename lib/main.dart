import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'core/config/firebase_bootstrap.dart';
import 'core/database/app_database.dart';
import 'core/errors/widgets/something_went_wrong_widget.dart';
import 'core/services/auth_preferences.dart';
import 'core/services/background/background_work.dart';
import 'core/services/settings_service.dart';
import 'core/sync/firestore_remote_datasource.dart';
import 'core/utils/logger.dart';
import 'features/notifications/data/datasources/message_template_datasource.dart';
import 'features/settings/data/datasources/user_profile_local_datasource.dart';
import 'features/settings/data/repositories/user_profile_repository.dart';
import 'features/settings/providers/settings_provider.dart';
import 'shared/providers/database_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use bundled Inter fonts — never block the UI waiting on fonts.gstatic.com.
  GoogleFonts.config.allowRuntimeFetching = false;

  await FirebaseBootstrap.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AppLogger.info('Initializing Muzammil Autos…');

  try {
    final AuthPreferences authPreferences = await AuthPreferences.create();
    final AppDatabase database = AppDatabase();
    final UserProfileRepository userProfileRepository = UserProfileRepository(
      UserProfileLocalDataSource(database),
      FirestoreRemoteDataSource(),
    );
    final SettingsService settingsService = SettingsService(
      repository: userProfileRepository,
      authPreferences: authPreferences,
    );

    final currentUser = FirebaseBootstrap.currentUser;
    if (currentUser != null) {
      // Keep startup offline-first: never block the first frame on Firestore.
      try {
        await settingsService
            .loadForUser(
              uid: currentUser.uid,
              email: currentUser.email ?? '',
              displayName: currentUser.displayName,
            )
            .timeout(const Duration(seconds: 8));
      } catch (e, st) {
        debugPrint('AutoCare: profile load timed out/failed: $e');
        AppLogger.error('Profile load failed at startup', error: e, stackTrace: st);
      }
    }

    try {
      await MessageTemplateDataSource(database).seedDefaultsIfEmpty();
    } catch (e, st) {
      AppLogger.error('Template seed failed', error: e, stackTrace: st);
    }

    // Background plugins can hang on some devices — never block UI on them.
    if (!kIsWeb) {
      unawaited(_safeInitBackground(currentUser != null, settingsService));
    }

    AppLogger.info('Services ready');
    runApp(
      ProviderScope(
        overrides: [
          settingsServiceProvider.overrideWithValue(settingsService),
          databaseProvider.overrideWithValue(database),
        ],
        child: const AutoCareApp(),
      ),
    );
  } catch (e, st) {
    AppLogger.error('Fatal startup failure', error: e, stackTrace: st);
    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SomethingWentWrongWidget(
            message:
                'Unable to start the app. Force-stop the app, clear app data, '
                'or reinstall, then open again.',
          ),
        ),
      ),
    );
  }
}

Future<void> _safeInitBackground(
  bool isSignedIn,
  SettingsService settingsService,
) async {
  try {
    await initializeBackgroundWork().timeout(const Duration(seconds: 5));
    if (isSignedIn) {
      await registerBackgroundSyncTask().timeout(const Duration(seconds: 5));
    }
    if (settingsService.notificationsEnabled) {
      await registerBackgroundTasks(
        dailyHour: settingsService.dailyReminderHour,
        dailyMinute: settingsService.dailyReminderMinute,
      ).timeout(const Duration(seconds: 5));
    }
  } catch (e, st) {
    debugPrint('AutoCare: background init skipped: $e');
    AppLogger.error('Background init failed', error: e, stackTrace: st);
  }
}
