import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../notifications/presentation/widgets/notification_widgets.dart';
import '../../domain/entities/maintenance_reminder.dart';
import '../../domain/entities/reminder_enums.dart';
import 'status_badge.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.reminder,
    this.onMarkCompleted,
    this.onSendReminder,
    this.onNotify,
    this.onWhatsApp,
    this.onEdit,
    this.onTap,
    this.compact = false,
    this.selected = false,
    this.selectionMode = false,
    this.onSelectionChanged,
  });

  final MaintenanceReminder reminder;
  final VoidCallback? onMarkCompleted;
  final VoidCallback? onSendReminder;
  final VoidCallback? onNotify;
  final VoidCallback? onWhatsApp;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;
  final bool compact;
  final bool selected;
  final bool selectionMode;
  final ValueChanged<bool>? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final NumberFormat odoFmt = NumberFormat('#,###');

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: selectionMode
          ? () => onSelectionChanged?.call(!selected)
          : (onTap ??
              () => context.push(AppRoutes.reminderDetailPath(reminder.id))),
      color: selected ? AppColors.primary.withValues(alpha: 0.08) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (selectionMode) ...[
                Checkbox(
                  value: selected,
                  onChanged: (v) => onSelectionChanged?.call(v ?? false),
                ),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.vehicleDisplayName ?? 'Vehicle',
                      style: AppTextStyles.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (reminder.registrationNumber != null)
                          reminder.registrationNumber!,
                        if (reminder.ownerName != null) reminder.ownerName!,
                      ].join(' · '),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: reminder.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: [
              _Meta(
                label: 'Current',
                value: '${odoFmt.format(reminder.currentOdometer)} KM',
              ),
              if (reminder.nextServiceOdometer != null)
                _Meta(
                  label: 'Target',
                  value: '${odoFmt.format(reminder.nextServiceOdometer!)} KM',
                ),
              if (reminder.nextServiceDate != null)
                _Meta(
                  label: 'Due date',
                  value: reminder.nextServiceDate!.formattedDate,
                ),
              RemainingKMWidget(remainingKm: reminder.remainingKm),
              RemainingDaysWidget(remainingDays: reminder.remainingDays),
            ],
          ),
          if (!compact && !selectionMode) ...[
            const SizedBox(height: AppSpacing.md),
            ReminderActionBar(
              onNotify: onNotify,
              onWhatsApp: onWhatsApp ?? onSendReminder,
              onMarkCompleted:
                  reminder.status != ReminderStatus.completed
                      ? onMarkCompleted
                      : null,
              onEdit: onEdit,
              showCompleted: reminder.status != ReminderStatus.completed,
            ),
          ],
        ],
      ),
    );
  }
}

class ReminderSummaryCard extends StatelessWidget {
  const ReminderSummaryCard({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    this.onTap,
  });

  final String label;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: AppTextStyles.headlineSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey500),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
