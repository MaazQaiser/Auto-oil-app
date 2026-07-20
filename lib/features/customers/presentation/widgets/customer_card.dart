import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/customer.dart';
import 'customer_avatar.dart';

/// List card for a single customer.
class CustomerCard extends ConsumerWidget {
  const CustomerCard({
    super.key,
    required this.customer,
    this.onTap,
    this.onLongPress,
  });

  final Customer customer;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int vehicleCount =
        ref.watch(customerVehicleCountProvider(customer.id));

    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: GestureDetector(
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            CustomerAvatar(name: customer.fullName),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.fullName,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    customer.phoneNumber,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      if (customer.city != null &&
                          customer.city!.isNotEmpty) ...[
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.grey500,
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            customer.city!,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.grey600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      const Icon(
                        Icons.directions_car_outlined,
                        size: 14,
                        color: AppColors.grey500,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$vehicleCount',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  customer.updatedAt.relative,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.grey400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
