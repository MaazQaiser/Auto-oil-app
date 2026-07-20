import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../reminders/domain/entities/reminder_enums.dart';
import '../../../reminders/presentation/providers/reminder_providers.dart';
import '../../../reminders/presentation/widgets/status_badge.dart';
import '../providers/notification_providers.dart';
import '../widgets/notification_widgets.dart';

class ReminderDetailPage extends ConsumerWidget {
  const ReminderDetailPage({super.key, required this.reminderId});

  final String reminderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(allRemindersStreamProvider);
    final odoFmt = NumberFormat('#,###');

    return Scaffold(
      appBar: const CustomAppBar(title: 'Reminder Detail'),
      body: allAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) {
          final reminder = list.where((r) => r.id == reminderId).firstOrNull;
          if (reminder == null) {
            return const Center(child: Text('Reminder not found'));
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            reminder.vehicleDisplayName ?? 'Vehicle',
                            style: AppTextStyles.titleLarge,
                          ),
                        ),
                        StatusBadge(status: reminder.status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      [
                        if (reminder.registrationNumber != null)
                          reminder.registrationNumber!,
                        if (reminder.ownerName != null) reminder.ownerName!,
                      ].join(' · '),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _row('Current ODO',
                        '${odoFmt.format(reminder.currentOdometer)} KM'),
                    if (reminder.nextServiceOdometer != null)
                      _row(
                        'Target ODO',
                        '${odoFmt.format(reminder.nextServiceOdometer!)} KM',
                      ),
                    if (reminder.remainingKm != null)
                      _row('Remaining KM', '${reminder.remainingKm}'),
                    _row('Last service', reminder.lastServiceDate.formattedDate),
                    if (reminder.nextServiceDate != null)
                      _row(
                        'Next service',
                        reminder.nextServiceDate!.formattedDate,
                      ),
                    if (reminder.lastReminderSent != null)
                      _row(
                        'Last reminder sent',
                        reminder.lastReminderSent!.formattedDate,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ReminderActionBar(
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
                      .notifySingle(reminder);
                  if (!context.mounted) return;
                  SnackBarHelper.success(context, 'Notification sent');
                },
                onWhatsApp: () {
                  context.push(AppRoutes.messageEditorPath(reminder.id));
                },
                onMarkCompleted: reminder.status == ReminderStatus.completed
                    ? null
                    : () async {
                        final ok = await ref
                            .read(reminderActionsProvider.notifier)
                            .markCompleted(reminder.id);
                        await ref
                            .read(whatsAppReminderHelperProvider)
                            .logCompleted(reminder);
                        if (!context.mounted) return;
                        if (ok) {
                          SnackBarHelper.success(context, 'Marked completed');
                        }
                      },
                onEdit: () {
                  context.push(
                    AppRoutes.vehicleDetailPath(reminder.vehicleId),
                  );
                },
                showCompleted: reminder.status != ReminderStatus.completed,
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () => context.push(
                  AppRoutes.vehicleDetailPath(reminder.vehicleId),
                ),
                icon: const Icon(Icons.directions_car_outlined),
                label: const Text('Open Vehicle'),
              ),
              if (reminder.customerId != null) ...[
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () => context.push(
                    AppRoutes.customerDetailPath(reminder.customerId!),
                  ),
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Open Customer'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
