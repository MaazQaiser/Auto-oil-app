import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/whatsapp_cta_button.dart';

/// Label + value row used on the customer detail screen.
class CustomerInfoTile extends StatelessWidget {
  const CustomerInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.onTap,
    this.compact = false,
    this.trailingAction,
  });

  final String label;
  final String value;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool compact;
  final Widget? trailingAction;

  @override
  Widget build(BuildContext context) {
    final bool hasValue = value.trim().isNotEmpty;
    final Color muted = Theme.of(context).brightness == Brightness.dark
        ? AppColors.silver
        : AppColors.grey600;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasValue ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: compact ? AppSpacing.sm : AppSpacing.md,
            horizontal: AppSpacing.xs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Container(
                  width: compact ? 36 : 40,
                  height: compact ? 36 : 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: compact ? 18 : 20,
                    color: AppColors.charcoal,
                  ),
                ),
                SizedBox(width: compact ? AppSpacing.sm : AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.labelSmall.copyWith(color: muted),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      hasValue ? value : '—',
                      style: (compact
                              ? AppTextStyles.bodyMedium
                              : AppTextStyles.bodyLarge)
                          .copyWith(
                        color: hasValue ? null : AppColors.grey400,
                        fontWeight:
                            hasValue ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailingAction != null && hasValue) trailingAction!,
            ],
          ),
        ),
      ),
    );
  }
}

/// Small icon button for phone / WhatsApp actions on info rows.
class CustomerInfoActionButton extends StatelessWidget {
  const CustomerInfoActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.useWhatsAppBrand = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool useWhatsAppBrand;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.grey100,
        foregroundColor: useWhatsAppBrand
            ? WhatsAppCtaButton.brandGreen
            : AppColors.charcoal,
        minimumSize: const Size(36, 36),
        padding: EdgeInsets.zero,
      ),
      icon: useWhatsAppBrand
          ? const FaIcon(FontAwesomeIcons.whatsapp, size: 18)
          : Icon(icon, size: 18),
    );
  }
}
