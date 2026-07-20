import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/logger.dart';
import '../../../features/notifications/data/datasources/reminder_history_datasource.dart';
import '../../../features/notifications/domain/services/notification_manager.dart';
import '../../../features/notifications/domain/services/notification_permission_service.dart';
import '../../../features/notifications/domain/services/notification_scheduler.dart';
import '../../../features/notifications/domain/services/notification_service.dart';
import '../../../features/reminders/data/datasources/reminder_local_datasource.dart';
import '../../../features/reminders/data/repositories/reminder_repository_impl.dart';
import '../../../features/reminders/domain/services/reminder_calculator.dart';

const String kDailyReminderTask = 'autocare_daily_reminder_check';
const String kMorningSummaryTask = 'autocare_morning_summary';
const String kCleanupTask = 'autocare_cleanup_notifications';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      AppLogger.info('Background task started: $taskName');
      final prefs = await SharedPreferences.getInstance();
      final db = AppDatabase();
      final calculator = const ReminderCalculator();
      final reminderRepo = ReminderRepositoryImpl(
        ReminderLocalDataSource(db, calculator: calculator),
      );
      final history = ReminderHistoryDataSource(db);
      final notifications = NotificationService();
      await notifications.initialize();
      final scheduler = NotificationScheduler(notifications, prefs);
      final manager = NotificationManager(
        reminderRepository: reminderRepo,
        notificationService: notifications,
        scheduler: scheduler,
        permissionService: NotificationPermissionService(),
        historyDataSource: history,
        notificationsEnabled: () =>
            prefs.getBool(AppConstants.notificationsEnabledKey) ?? true,
        weeklySummaryEnabled: () =>
            prefs.getBool(AppConstants.weeklySummaryEnabledKey) ?? true,
        monthlySummaryEnabled: () =>
            prefs.getBool(AppConstants.monthlySummaryEnabledKey) ?? true,
      );

      switch (taskName) {
        case kDailyReminderTask:
        case kMorningSummaryTask:
          await manager.runReminderCheck();
          break;
        case kCleanupTask:
          await history.cleanupOlderThan(const Duration(days: 90));
          break;
        default:
          await manager.runReminderCheck();
      }

      await db.close();
      return true;
    } catch (e, st) {
      AppLogger.error('Background task failed', error: e, stackTrace: st);
      return false;
    }
  });
}

Future<void> initializeBackgroundWork() async {
  if (kIsWeb) return;
  try {
    await Workmanager().initialize(callbackDispatcher);
    AppLogger.info('Workmanager initialized');
  } catch (e, st) {
    AppLogger.error('Workmanager init failed', error: e, stackTrace: st);
  }
}

Future<void> registerBackgroundTasks({
  required int dailyHour,
  required int dailyMinute,
}) async {
  if (kIsWeb) return;
  try {
    await Workmanager().registerPeriodicTask(
      kDailyReminderTask,
      kDailyReminderTask,
      frequency: const Duration(hours: 12),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      constraints: Constraints(networkType: NetworkType.notRequired),
    );

    await Workmanager().registerPeriodicTask(
      kMorningSummaryTask,
      kMorningSummaryTask,
      frequency: const Duration(hours: 24),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      constraints: Constraints(networkType: NetworkType.notRequired),
      inputData: <String, dynamic>{
        'hour': dailyHour,
        'minute': dailyMinute,
      },
    );

    await Workmanager().registerPeriodicTask(
      kCleanupTask,
      kCleanupTask,
      frequency: const Duration(days: 7),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );

    AppLogger.info('Background tasks registered');
  } catch (e, st) {
    AppLogger.error(
      'Failed to register background tasks',
      error: e,
      stackTrace: st,
    );
  }
}

Future<void> cancelBackgroundTasks() async {
  if (kIsWeb) return;
  try {
    await Workmanager().cancelByUniqueName(kDailyReminderTask);
    await Workmanager().cancelByUniqueName(kMorningSummaryTask);
    await Workmanager().cancelByUniqueName(kCleanupTask);
  } catch (e) {
    AppLogger.warning('cancelBackgroundTasks: $e');
  }
}
