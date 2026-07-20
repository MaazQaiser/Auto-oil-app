import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/errors/widgets/app_error_widget.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/search_field.dart';
import '../../../customers/presentation/providers/customer_providers.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../../service_records/presentation/providers/service_record_providers.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../data/debug/reminder_seed_data.dart';
import '../../domain/entities/maintenance_reminder.dart';
import '../../domain/entities/reminder_enums.dart';
import '../providers/reminder_providers.dart';
import '../widgets/reminder_card.dart';
import '../widgets/reminder_filter_sheet.dart';

class RemindersPage extends ConsumerStatefulWidget {
  const RemindersPage({super.key});

  @override
  ConsumerState<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends ConsumerState<RemindersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    ReminderStatus.upcoming,
    ReminderStatus.due,
    ReminderStatus.overdue,
    ReminderStatus.completed,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(reminderStatusTabProvider.notifier).state =
            _tabs[_tabController.index];
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(notificationManagerProvider).runReminderCheck();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _bulkWhatsApp(List<MaintenanceReminder> selected) async {
    for (final r in selected) {
      if (!mounted) return;
      await context.push(AppRoutes.messageEditorPath(r.id));
    }
  }

  Future<void> _bulkComplete(List<MaintenanceReminder> selected) async {
    for (final r in selected) {
      await ref.read(reminderActionsProvider.notifier).markCompleted(r.id);
      await ref.read(whatsAppReminderHelperProvider).logCompleted(r);
    }
    ref.read(reminderSelectionProvider.notifier).state = {};
    ref.read(reminderSelectionModeProvider.notifier).state = false;
    if (!mounted) return;
    SnackBarHelper.success(context, 'Marked ${selected.length} completed');
  }

  Future<void> _bulkDismiss(List<MaintenanceReminder> selected) async {
    for (final r in selected) {
      await ref.read(whatsAppReminderHelperProvider).logDismissed(r);
    }
    ref.read(reminderSelectionProvider.notifier).state = {};
    ref.read(reminderSelectionModeProvider.notifier).state = false;
    if (!mounted) return;
    SnackBarHelper.info(context, 'Dismissed ${selected.length} reminders');
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<MaintenanceReminder>> remindersAsync =
        ref.watch(filteredRemindersProvider);
    final bool selectionMode = ref.watch(reminderSelectionModeProvider);
    final Set<String> selectedIds = ref.watch(reminderSelectionProvider);
    final bool whatsappEnabled =
        ref.watch(settingsWhatsAppEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectionMode
              ? '${selectedIds.length} selected'
              : StringConstants.reminders,
        ),
        leading: selectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ref.read(reminderSelectionModeProvider.notifier).state =
                      false;
                  ref.read(reminderSelectionProvider.notifier).state = {};
                },
              )
            : null,
        actions: [
          if (!selectionMode) ...[
            IconButton(
              icon: const Icon(Icons.checklist_rounded),
              tooltip: 'Multi-select',
              onPressed: () {
                ref.read(reminderSelectionModeProvider.notifier).state = true;
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: () => ReminderFilterSheet.show(context),
            ),
            IconButton(
              icon: const Icon(Icons.history_rounded),
              tooltip: 'History',
              onPressed: () => context.push(AppRoutes.reminderHistory),
            ),
            if (kDebugMode)
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'seed') {
                    final count = await ReminderSeedData.seedReminders(
                      customerRepository:
                          ref.read(customerRepositoryProvider),
                      vehicleRepository: ref.read(vehicleRepositoryProvider),
                      serviceRecordRepository:
                          ref.read(serviceRecordRepositoryProvider),
                      reminderRepository:
                          ref.read(reminderRepositoryProvider),
                    );
                    if (!context.mounted) return;
                    SnackBarHelper.info(context, 'Seeded $count reminders');
                    ref.invalidate(allRemindersStreamProvider);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'seed',
                    child: Text('Insert 100 demo reminders'),
                  ),
                ],
              ),
          ] else ...[
            if (whatsappEnabled)
              IconButton(
                icon: const Icon(Icons.chat_rounded),
                tooltip: 'Send WhatsApp',
                onPressed: () {
                  final list = remindersAsync.valueOrNull ?? [];
                  final selected =
                      list.where((r) => selectedIds.contains(r.id)).toList();
                  if (selected.isEmpty) return;
                  _bulkWhatsApp(selected);
                },
              ),
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              tooltip: 'Mark Completed',
              onPressed: () {
                final list = remindersAsync.valueOrNull ?? [];
                final selected =
                    list.where((r) => selectedIds.contains(r.id)).toList();
                if (selected.isEmpty) return;
                _bulkComplete(selected);
              },
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              tooltip: 'Dismiss',
              onPressed: () {
                final list = remindersAsync.valueOrNull ?? [];
                final selected =
                    list.where((r) => selectedIds.contains(r.id)).toList();
                if (selected.isEmpty) return;
                _bulkDismiss(selected);
              },
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Due Today'),
            Tab(text: 'Overdue'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: SearchField(
              hint: 'Search customer, registration, vehicle…',
              onChanged: (v) =>
                  ref.read(reminderSearchQueryProvider.notifier).state = v,
            ),
          ),
          Expanded(
            child: remindersAsync.when(
              loading: () => const Center(child: LoadingIndicator()),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(allRemindersStreamProvider),
              ),
              data: (reminders) {
                if (reminders.isEmpty) {
                  return const EmptyState(
                    title: 'No reminders',
                    message:
                        'Reminders appear when service records are saved.',
                    icon: Icons.notifications_none_rounded,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    0,
                    AppSpacing.screenPadding,
                    AppSpacing.xxxl,
                  ),
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final r = reminders[index];
                    return ReminderCard(
                      reminder: r,
                      selectionMode: selectionMode,
                      selected: selectedIds.contains(r.id),
                      onSelectionChanged: (selected) {
                        final next = {...selectedIds};
                        if (selected) {
                          next.add(r.id);
                        } else {
                          next.remove(r.id);
                        }
                        ref.read(reminderSelectionProvider.notifier).state =
                            next;
                      },
                      onMarkCompleted: () async {
                        final ok = await ref
                            .read(reminderActionsProvider.notifier)
                            .markCompleted(r.id);
                        await ref
                            .read(whatsAppReminderHelperProvider)
                            .logCompleted(r);
                        if (!context.mounted) return;
                        if (ok) {
                          SnackBarHelper.success(
                            context,
                            'Reminder marked completed',
                          );
                        }
                      },
                      onNotify: () async {
                        final granted = await ref
                            .read(notificationPermissionServiceProvider)
                            .ensureGranted();
                        if (!context.mounted) return;
                        if (!granted) {
                          SnackBarHelper.warning(
                            context,
                            'Notification permission denied',
                          );
                          return;
                        }
                        await ref
                            .read(notificationManagerProvider)
                            .notifySingle(r);
                        if (!context.mounted) return;
                        SnackBarHelper.success(context, 'Notification sent');
                      },
                      onWhatsApp: whatsappEnabled
                          ? () => context.push(
                                AppRoutes.messageEditorPath(r.id),
                              )
                          : null,
                      onEdit: () {
                        context.push(
                          AppRoutes.vehicleDetailPath(r.vehicleId),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Local read of WhatsApp shortcut setting without importing full settings page.
final settingsWhatsAppEnabledProvider = Provider<bool>((ref) {
  return ref.watch(settingsServiceProvider).whatsappShortcutEnabled;
});
