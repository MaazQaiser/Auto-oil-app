import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Label + value row used on the customer detail screen.
class CustomerInfoTile extends StatelessWidget {
  const CustomerInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasValue = value.trim().isNotEmpty;

    return InkWell(
      onTap: hasValue ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22, color: AppColors.primary),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    hasValue ? value : '—',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: hasValue
                          ? null
                          : AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null && hasValue)
              const Icon(Icons.open_in_new_rounded, size: 16, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
