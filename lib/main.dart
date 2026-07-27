import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/services/auth_preferences.dart';
import 'core/services/background/background_work.dart';
import 'core/services/settings_service.dart';
import 'core/sync/firestore_remote_datasource.dart';
import 'core/utils/logger.dart';
import 'features/notifications/data/datasources/message_template_datasource.dart';
import 'features/settings/data/datasources/user_profile_local_datasource.dart';
import 'features/settings/data/repositories/user_profile_repository.dart';
import 'features/settings/providers/settings_provider.dart';
import 'firebase_options.dart';
import 'shared/providers/database_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AppLogger.info('Initializing Muzammil Autos…');

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

  final User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await settingsService.loadForUser(
      uid: currentUser.uid,
      email: currentUser.email ?? '',
      displayName: currentUser.displayName,
    );
  }

  await MessageTemplateDataSource(database).seedDefaultsIfEmpty();

  if (!kIsWeb) {
    await initializeBackgroundWork();
    if (currentUser != null) {
      await registerBackgroundSyncTask();
    }
  }

  if (settingsService.notificationsEnabled) {
    await registerBackgroundTasks(
      dailyHour: settingsService.dailyReminderHour,
      dailyMinute: settingsService.dailyReminderMinute,
    );
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
}
