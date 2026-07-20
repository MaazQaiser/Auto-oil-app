import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Circular avatar showing the customer's first initial.
class CustomerAvatar extends StatelessWidget {
  const CustomerAvatar({
    super.key,
    required this.name,
    this.size = 48,
    this.fontSize,
  });

  final String name;
  final double size;
  final double? fontSize;

  String get _initial {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Text(
        _initial,
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.primary,
          fontSize: fontSize ?? size * 0.4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
