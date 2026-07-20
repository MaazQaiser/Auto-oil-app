import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/reminder_enums.dart';

Color reminderStatusColor(ReminderStatus status) {
  return switch (status) {
    ReminderStatus.upcoming => AppColors.info,
    ReminderStatus.due => AppColors.warning,
    ReminderStatus.overdue => AppColors.error,
    ReminderStatus.completed => AppColors.success,
  };
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final ReminderStatus status;

  @override
  Widget build(BuildContext context) {
    final Color color = reminderStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class RemainingKMWidget extends StatelessWidget {
  const RemainingKMWidget({super.key, required this.remainingKm});

  final int? remainingKm;

  @override
  Widget build(BuildContext context) {
    if (remainingKm == null) {
      return Text('—', style: AppTextStyles.labelSmall);
    }
    final bool overdue = remainingKm! < 0;
    return Text(
      overdue ? '${remainingKm!.abs()} KM over' : '$remainingKm KM left',
      style: AppTextStyles.labelSmall.copyWith(
        color: overdue ? AppColors.error : AppColors.grey700,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class RemainingDaysWidget extends StatelessWidget {
  const RemainingDaysWidget({super.key, required this.remainingDays});

  final int? remainingDays;

  @override
  Widget build(BuildContext context) {
    if (remainingDays == null) {
      return Text('—', style: AppTextStyles.labelSmall);
    }
    final bool overdue = remainingDays! < 0;
    final String label = overdue
        ? '${remainingDays!.abs()} days overdue'
        : remainingDays == 0
            ? 'Due today'
            : '$remainingDays days left';
    return Text(
      label,
      style: AppTextStyles.labelSmall.copyWith(
        color: overdue
            ? AppColors.error
            : remainingDays == 0
                ? AppColors.warning
                : AppColors.grey700,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
