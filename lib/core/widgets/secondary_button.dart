import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'loading_indicator.dart';

/// Secondary outlined action button.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Widget child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: LoadingIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: AppTextStyles.labelLarge.copyWith(
                color: colorScheme.onSurface,
              )),
            ],
          );

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(isExpanded ? double.infinity : 0, 48),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      child: child,
    );
  }
}
