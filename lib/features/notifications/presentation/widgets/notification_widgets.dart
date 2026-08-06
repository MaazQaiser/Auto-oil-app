import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/whatsapp_cta_button.dart';

class WhatsAppButton extends StatelessWidget {
  const WhatsAppButton({
    super.key,
    required this.onPressed,
    this.label = 'WhatsApp',
    this.compact = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return WhatsAppIconButton(
        onPressed: onPressed,
        tooltip: label,
        filled: false,
      );
    }
    return WhatsAppCtaButton(
      onPressed: onPressed,
      label: label,
      isExpanded: false,
    );
  }
}

class ReminderActionBar extends StatelessWidget {
  const ReminderActionBar({
    super.key,
    this.onNotify,
    this.onWhatsApp,
    this.onMarkCompleted,
    this.onEdit,
    this.showCompleted = true,
  });

  final VoidCallback? onNotify;
  final VoidCallback? onWhatsApp;
  final VoidCallback? onMarkCompleted;
  final VoidCallback? onEdit;
  final bool showCompleted;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        if (onNotify != null)
          OutlinedButton.icon(
            onPressed: onNotify,
            icon: const Icon(Icons.notifications_active_outlined, size: 18),
            label: const Text('Notify'),
          ),
        if (onWhatsApp != null)
          WhatsAppButton(onPressed: onWhatsApp),
        if (showCompleted && onMarkCompleted != null)
          FilledButton(
            onPressed: onMarkCompleted,
            child: const Text('Mark Completed'),
          ),
        if (onEdit != null)
          TextButton(
            onPressed: onEdit,
            child: const Text('Edit Reminder'),
          ),
      ],
    );
  }
}

class MessageTemplateCard extends StatelessWidget {
  const MessageTemplateCard({
    super.key,
    required this.name,
    required this.preview,
    required this.categoryLabel,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final String name;
  final String preview;
  final String categoryLabel;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        onTap: onTap ?? onEdit,
        title: Text(name, style: AppTextStyles.titleSmall),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              categoryLabel,
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              preview,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}

class ReminderHistoryTile extends StatelessWidget {
  const ReminderHistoryTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String timeLabel;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: AppTextStyles.titleSmall),
      subtitle: Text(subtitle),
      trailing: Text(
        timeLabel,
        style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey500),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.title,
    required this.body,
    this.onTap,
  });

  final String title;
  final String body;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const CircleAvatar(
        child: Icon(Icons.notifications_outlined),
      ),
      title: Text(title),
      subtitle: Text(body),
    );
  }
}
