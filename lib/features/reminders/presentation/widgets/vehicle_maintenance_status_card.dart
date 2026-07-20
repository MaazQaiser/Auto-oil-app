import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/section_title.dart';
import '../../domain/entities/maintenance_reminder.dart';
import '../providers/reminder_providers.dart';
import 'status_badge.dart';

/// Maintenance status card shown on vehicle detail.
class VehicleMaintenanceStatusCard extends ConsumerWidget {
  const VehicleMaintenanceStatusCard({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(activeReminderForVehicleProvider(vehicleId));
    final odoFmt = NumberFormat('#,###');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Maintenance Status',
          padding: EdgeInsets.only(bottom: AppSpacing.md),
        ),
        async.when(
          loading: () => const AppCard(
            child: Center(child: LoadingIndicator(size: 28)),
          ),
          error: (e, _) => AppCard(child: Text(e.toString())),
          data: (MaintenanceReminder? reminder) {
            if (reminder == null) {
              return AppCard(
                child: Text(
                  'No active maintenance reminder.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              );
            }

            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusBadge(status: reminder.status),
                      const Spacer(),
                      Text(
                        reminder.reminderType.label,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.xxl,
                    runSpacing: AppSpacing.md,
                    children: [
                      RemainingKMWidget(remainingKm: reminder.remainingKm),
                      RemainingDaysWidget(
                        remainingDays: reminder.remainingDays,
                      ),
                      _pair(
                        'Current Reading',
                        '${odoFmt.format(reminder.currentOdometer)} KM',
                      ),
                      if (reminder.nextServiceOdometer != null)
                        _pair(
                          'Next Oil Change ODO',
                          '${odoFmt.format(reminder.nextServiceOdometer!)} KM',
                        ),
                      _pair(
                        'Last Oil Change',
                        reminder.lastServiceDate.formattedDate,
                      ),
                      if (reminder.nextServiceDate != null)
                        _pair(
                          'Next Due Date',
                          reminder.nextServiceDate!.formattedDate,
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _pair(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey500),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
