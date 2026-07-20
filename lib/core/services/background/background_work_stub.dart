import '../../../../core/utils/logger.dart';

/// Stub used on web / unsupported platforms.
Future<void> initializeBackgroundWork() async {
  AppLogger.info('Background work skipped (unsupported platform)');
}

Future<void> registerBackgroundTasks({
  required int dailyHour,
  required int dailyMinute,
}) async {}

Future<void> cancelBackgroundTasks() async {}
