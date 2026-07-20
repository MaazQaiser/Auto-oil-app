import 'package:flutter/material.dart';

import '../constants/string_constants.dart';
import '../theme/app_spacing.dart';
import 'primary_button.dart';
import 'secondary_button.dart';

/// Reusable confirmation dialog.
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = StringConstants.confirm,
    this.cancelLabel = StringConstants.cancel,
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = StringConstants.confirm,
    String cancelLabel = StringConstants.cancel,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      actions: [
        SecondaryButton(
          label: cancelLabel,
          onPressed: () => Navigator.of(context).pop(false),
          isExpanded: false,
        ),
        const SizedBox(width: AppSpacing.sm),
        PrimaryButton(
          label: confirmLabel,
          onPressed: () => Navigator.of(context).pop(true),
          isExpanded: false,
        ),
      ],
    );
  }
}
