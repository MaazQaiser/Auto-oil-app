import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/router/route_names.dart';
import 'core/sync/sync_providers.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/domain/services/notification_service.dart';
import 'features/notifications/presentation/providers/notification_providers.dart';
import 'features/reminders/presentation/providers/reminder_providers.dart';
import 'features/settings/providers/settings_provider.dart';
import 'shared/providers/theme_provider.dart';

/// Root application widget with resume-time reminder checks.
class AutoCareApp extends ConsumerStatefulWidget {
  const AutoCareApp({super.key});

  @override
  ConsumerState<AutoCareApp> createState() => _AutoCareAppState();
}

class _AutoCareAppState extends ConsumerState<AutoCareApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(notificationBootstrapProvider.future);
      _handlePendingNotification();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive) {
      if (state == AppLifecycleState.resumed) {
        ref.read(notificationManagerProvider).runReminderCheck();
        _handlePendingNotification();
      }
      ref.read(syncEngineProvider).scheduleSync();
    }
  }

  void _handlePendingNotification() {
    final pending = ref.read(pendingNotificationPayloadProvider);
    if (pending == null) return;
    ref.read(pendingNotificationPayloadProvider.notifier).state = null;

    final router = ref.read(appRouterProvider);
    final actionId = pending.actionId;
    final payload = pending.payload;

    if (actionId == NotificationActions.markComplete &&
        payload?.reminderId != null) {
      ref
          .read(reminderActionsProvider.notifier)
          .markCompleted(payload!.reminderId!);
      router.go(AppRoutes.reminders);
      return;
    }

    if (actionId == NotificationActions.dismiss) {
      return;
    }

    final route = resolveNotificationRoute(pending);
    router.go(route);
  }

  @override
  Widget build(BuildContext context) {
    // Keep Firebase offline sync warm while signed in.
    ref.watch(syncBootstrapProvider);
    ref.watch(userProfileBootstrapProvider);

    // Re-run handler when a notification sets pending payload.
    ref.listen(pendingNotificationPayloadProvider, (prev, next) {
      if (next != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handlePendingNotification();
        });
      }
    });

    final router = ref.watch(appRouterProvider);
    final ThemeMode themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
