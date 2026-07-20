import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/services/background/background_work.dart';
import 'core/services/settings_service.dart';
import 'core/utils/logger.dart';
import 'features/notifications/data/datasources/message_template_datasource.dart';
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

  final SettingsService settingsService = await SettingsService.create();
  final AppDatabase database = AppDatabase();

  await MessageTemplateDataSource(database).seedDefaultsIfEmpty();

  if (settingsService.notificationsEnabled) {
    await initializeBackgroundWork();
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
