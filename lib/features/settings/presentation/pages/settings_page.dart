import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/background/background_work.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../providers/settings_provider.dart';

/// Settings screen — profile, appearance, notifications, WhatsApp, about.
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final AppSettings settings = ref.watch(settingsProvider);
    final profile = ref.watch(settingsServiceProvider);
    final firebaseUser = fb.FirebaseAuth.instance.currentUser;
    final firebaseEmail = firebaseUser?.email ?? '';

    return Scaffold(
      appBar: const CustomAppBar(title: StringConstants.settings),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const SectionTitle(
            title: 'User Profile',
            padding: EdgeInsets.only(bottom: AppSpacing.md),
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.charcoal,
                    child: Icon(Icons.person_rounded, color: AppColors.gold),
                  ),
                  title: Text(profile.userName),
                  subtitle: Text(
                    firebaseEmail.isNotEmpty ? firebaseEmail : 'Tap to edit profile',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('Full Name'),
                  subtitle: Text(profile.userName),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _editSetting(
                    context,
                    title: 'Full Name',
                    initial: profile.userName,
                    onSave: (v) async {
                      if (v.isEmpty) return;
                      await ref.read(settingsServiceProvider).setUserName(v);
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(
                    firebaseEmail.isNotEmpty ? firebaseEmail : 'Not set',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: const Text('Phone'),
                  subtitle: Text(
                    profile.userPhone.isEmpty ? 'Not set' : profile.userPhone,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _editSetting(
                    context,
                    title: 'Phone',
                    initial: profile.userPhone,
                    keyboard: TextInputType.phone,
                    onSave: (v) =>
                        ref.read(settingsServiceProvider).setUserPhone(v),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline_rounded),
                  title: const Text('Reset Password'),
                  subtitle: Text(
                    firebaseEmail.isNotEmpty
                        ? 'Send reset link to $firebaseEmail'
                        : 'Sign in to reset password',
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: firebaseEmail.isNotEmpty
                      ? () => _sendPasswordReset(context, firebaseEmail)
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          const SectionTitle(
            title: 'Appearance',
            padding: EdgeInsets.only(bottom: AppSpacing.md),
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringConstants.theme, style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSpacing.md),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(StringConstants.lightTheme),
                      icon: Icon(Icons.light_mode_outlined, size: 18),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(StringConstants.darkTheme),
                      icon: Icon(Icons.dark_mode_outlined, size: 18),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(StringConstants.systemTheme),
                      icon: Icon(Icons.settings_suggest_outlined, size: 18),
                    ),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (selection) {
                    ref
                        .read(settingsProvider.notifier)
                        .setThemeMode(selection.first);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          const SectionTitle(
            title: 'Preferences',
            padding: EdgeInsets.only(bottom: AppSpacing.md),
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: const Text(StringConstants.language),
                  subtitle: Text(
                    settings.language.toUpperCase(),
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: settings.language,
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'es', child: Text('Español')),
                        DropdownMenuItem(value: 'fr', child: Text('Français')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        ref.read(settingsProvider.notifier).setLanguage(value);
                        SnackBarHelper.info(
                          context,
                          'Language set to ${value.toUpperCase()}',
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          const SectionTitle(
            title: 'Notification Settings',
            padding: EdgeInsets.only(bottom: AppSpacing.md),
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: const Text('Enable Notifications'),
              subtitle: Text(
                settings.notificationsEnabled ? 'Enabled' : 'Disabled',
                style: AppTextStyles.bodySmall,
              ),
              value: settings.notificationsEnabled,
              activeThumbColor: AppColors.primary,
              onChanged: (value) async {
                await ref
                    .read(settingsProvider.notifier)
                    .setNotificationsEnabled(value);
                if (!context.mounted) return;
                if (value) {
                  final granted = await ref
                      .read(notificationPermissionServiceProvider)
                      .ensureGranted();
                  final s = ref.read(settingsProvider);
                  await initializeBackgroundWork();
                  await registerBackgroundTasks(
                    dailyHour: s.dailyReminderHour,
                    dailyMinute: s.dailyReminderMinute,
                  );
                  if (!context.mounted) return;
                  if (!granted) {
                    SnackBarHelper.warning(
                      context,
                      'Notifications may be blocked in system settings.',
                    );
                  }
                } else {
                  await cancelBackgroundTasks();
                  await ref
                      .read(notificationSchedulerProvider)
                      .cancelScheduledSummaries();
                  await ref.read(notificationServiceProvider).cancelAll();
                }
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          const SectionTitle(
            title: 'WhatsApp',
            padding: EdgeInsets.only(bottom: AppSpacing.md),
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(
                    Icons.chat_rounded,
                    color: Color(0xFF25D366),
                  ),
                  title: const Text('Enable WhatsApp Shortcut'),
                  subtitle: const Text(
                    'Opens WhatsApp with a pre-filled message (does not auto-send)',
                  ),
                  value: settings.whatsappShortcutEnabled,
                  onChanged: (v) => ref
                      .read(settingsProvider.notifier)
                      .setWhatsappShortcutEnabled(v),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.message_outlined),
                  title: const Text('Message Templates'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push(AppRoutes.messageTemplates),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.history_rounded),
                  title: const Text('Reminder History'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push(AppRoutes.reminderHistory),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          const SectionTitle(
            title: 'About',
            padding: EdgeInsets.only(bottom: AppSpacing.md),
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringConstants.appName, style: AppTextStyles.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Version 1.0.0 · Muzammil Autos',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Developed by Maaz Qaiser',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          FilledButton.icon(
            onPressed: () => _confirmSignOut(context),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign Out'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Future<void> _editSetting(
    BuildContext context, {
    required String title,
    required String initial,
    required Future<void> Function(String) onSave,
    TextInputType? keyboard,
  }) async {
    final ctrl = TextEditingController(text: initial);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          keyboardType: keyboard,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await onSave(ctrl.text.trim());
      if (!context.mounted) return;
      setState(() {});
      SnackBarHelper.success(context, 'Saved');
    }
  }

  Future<void> _sendPasswordReset(BuildContext context, String email) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Password'),
        content: Text(
          'A password reset link will be sent to $email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Send Link'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await fb.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!context.mounted) return;
      SnackBarHelper.success(context, 'Password reset email sent');
    } catch (e) {
      if (!context.mounted) return;
      SnackBarHelper.error(context, 'Failed to send reset email');
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(authControllerProvider.notifier).signOut();
    if (!context.mounted) return;
    context.go(AppRoutes.login);
  }
}
