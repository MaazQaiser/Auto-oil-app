import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Vehicle image placeholder / avatar.
class VehicleAvatar extends StatelessWidget {
  const VehicleAvatar({
    super.key,
    this.size = 56,
    this.heroTag,
  });

  final double size;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final Widget child = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Icon(
        Icons.directions_car_filled_rounded,
        size: size * 0.48,
        color: AppColors.primary,
      ),
    );

    if (heroTag == null) return child;
    return Hero(tag: heroTag!, child: child);
  }
}

/// Small status / category badge.
class VehicleBadge extends StatelessWidget {
  const VehicleBadge({
    super.key,
    required this.label,
    this.color = AppColors.primary,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Fuel type chip.
class FuelChip extends StatelessWidget {
  const FuelChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VehicleBadge(label: label, color: AppColors.secondary);
  }
}

/// Transmission type chip.
class TransmissionChip extends StatelessWidget {
  const TransmissionChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VehicleBadge(label: label, color: AppColors.info);
  }
}
