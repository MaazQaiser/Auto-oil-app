import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Muzammil Autos brand logo mark from the identity kit.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = 120,
    this.showWordmark = false,
  });

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppConfig.logoAsset,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Icon(
            Icons.settings_suggest_rounded,
            size: size * 0.45,
            color: AppColors.gold,
          ),
        ),
        if (showWordmark) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppConfig.workshopName,
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppConfig.workshopTagline.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.silver,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
