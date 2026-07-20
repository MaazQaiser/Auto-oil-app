import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/logger.dart';

/// Handles notification permission requests across platforms.
class NotificationPermissionService {
  Future<bool> isGranted() async {
    if (kIsWeb) return true;
    try {
      final PermissionStatus status = await Permission.notification.status;
      return status.isGranted || status.isLimited;
    } catch (e) {
      AppLogger.warning('Notification permission check failed: $e');
      return false;
    }
  }

  Future<bool> request() async {
    if (kIsWeb) return true;
    try {
      final PermissionStatus status = await Permission.notification.request();
      final bool granted = status.isGranted || status.isLimited;
      AppLogger.info('Notification permission granted: $granted');
      return granted;
    } catch (e, st) {
      AppLogger.error(
        'Notification permission request failed',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  Future<bool> ensureGranted() async {
    if (await isGranted()) return true;
    return request();
  }

  Future<void> openSystemSettings() => openAppSettings();
}
