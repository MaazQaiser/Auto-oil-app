import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/vehicle.dart';
import 'vehicle_avatar.dart';

/// List / customer-profile card for a vehicle.
class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
    this.compact = false,
    this.showOwner = true,
  });

  final Vehicle vehicle;
  final VoidCallback? onTap;
  final bool compact;
  final bool showOwner;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          VehicleAvatar(
            size: compact ? 48 : 56,
            heroTag: 'vehicle-avatar-${vehicle.id}',
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.displayName,
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  vehicle.registrationNumber,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      vehicle.formattedOdo,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                    if (vehicle.year != null)
                      Text(
                        '${vehicle.year}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    FuelChip(label: vehicle.fuelType.label),
                    if (!compact)
                      TransmissionChip(label: vehicle.transmission.label),
                  ],
                ),
                if (showOwner && vehicle.ownerName != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    vehicle.ownerName!,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.grey500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (compact) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    vehicle.serviceSummary,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
        ],
      ),
    );
  }
}
