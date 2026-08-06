import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Primary black CTA with the official WhatsApp brand icon.
class WhatsAppCtaButton extends StatelessWidget {
  const WhatsAppCtaButton({
    super.key,
    required this.onPressed,
    this.label = 'WhatsApp',
    this.isExpanded = true,
    this.height = 48,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isExpanded;
  final double height;

  static const Color brandGreen = Color(0xFF25D366);

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.charcoal,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.grey400,
        minimumSize: Size(isExpanded ? double.infinity : 0, height),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FaIcon(
            FontAwesomeIcons.whatsapp,
            size: 20,
            color: brandGreen,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

/// Compact circular WhatsApp action used in toolbars and headers.
class WhatsAppIconButton extends StatelessWidget {
  const WhatsAppIconButton({
    super.key,
    required this.onPressed,
    this.tooltip = 'WhatsApp',
    this.filled = true,
  });

  final VoidCallback? onPressed;
  final String tooltip;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final Widget icon = const FaIcon(
      FontAwesomeIcons.whatsapp,
      size: 20,
      color: WhatsAppCtaButton.brandGreen,
    );

    if (filled) {
      return IconButton.filled(
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.charcoal,
          foregroundColor: AppColors.white,
          minimumSize: const Size(44, 44),
        ),
        icon: icon,
      );
    }

    return IconButton.outlined(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        foregroundColor: AppColors.charcoal,
        side: const BorderSide(color: AppColors.grey300),
        minimumSize: const Size(44, 44),
      ),
      icon: icon,
    );
  }
}
