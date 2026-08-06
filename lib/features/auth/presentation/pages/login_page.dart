import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../settings/providers/settings_provider.dart';
import '../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _resetEmailSent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lastEmail = ref.read(settingsServiceProvider).lastLoginEmail;
      if (lastEmail != null &&
          lastEmail.isNotEmpty &&
          _emailCtrl.text.isEmpty) {
        _emailCtrl.text = lastEmail;
      }
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    await ref
        .read(authControllerProvider.notifier)
        .signIn(_emailCtrl.text, _passwordCtrl.text);

    if (!mounted) return;
    final authState = ref.read(authControllerProvider);
    authState.whenOrNull(
      error: (e, _) => _showError(e.toString()),
      data: (_) => context.go(AppRoutes.dashboard),
    );
  }

  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      _showError('Enter your email above, then tap Forgot password.');
      return;
    }

    await ref.read(authControllerProvider.notifier).sendPasswordReset(email);

    if (!mounted) return;
    final authState = ref.read(authControllerProvider);
    authState.whenOrNull(
      error: (e, _) => _showError(e.toString()),
      data: (_) => setState(() => _resetEmailSent = true),
    );
  }

  Future<void> _showCreateAccountDialog() async {
    final emailController = TextEditingController(text: _emailCtrl.text);
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isCreating = false;
    bool obscurePassword = true;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> createAccount() async {
              if (!formKey.currentState!.validate()) return;

              setDialogState(() => isCreating = true);
              await ref
                  .read(authControllerProvider.notifier)
                  .createAccount(emailController.text, passwordController.text);
              if (!mounted || !dialogContext.mounted) return;

              final authState = ref.read(authControllerProvider);
              authState.whenOrNull(
                error: (error, _) {
                  setDialogState(() => isCreating = false);
                  _showError(error.toString());
                },
                data: (_) {
                  Navigator.of(dialogContext).pop();
                  context.go(AppRoutes.dashboard);
                },
              );
            }

            return AlertDialog(
              title: const Text('Create account'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.newUsername],
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                        ),
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty || !email.contains('@')) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        autofillHints: const [AutofillHints.newPassword],
                        decoration: InputDecoration(
                          labelText: 'Password',
                          helperText: 'At least 6 characters',
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setDialogState(
                              () => obscurePassword = !obscurePassword,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if ((value?.length ?? 0) < 6) {
                            return 'Use at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => createAccount(),
                        decoration: const InputDecoration(
                          labelText: 'Confirm password',
                        ),
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isCreating
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: isCreating ? null : createAccount,
                  child: isCreating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create account'),
                ),
              ],
            );
          },
        );
      },
    );

    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState is AsyncLoading;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.charcoal, Color(0xFF1A1A1A), AppColors.charcoal],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: AppSpacing.xxl,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand
                    const Center(
                      child: BrandLogo(size: 100, showWordmark: true),
                    ),
                    const SizedBox(height: AppSpacing.huge),

                    // Heading
                    Text(
                      'Welcome back',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppConfig.workshopName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.silver,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),

                    // Email field
                    _InputField(
                      controller: _emailCtrl,
                      label: 'Email',
                      hint: 'owner@muzammilautos.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.email_outlined,
                      enabled: !isLoading,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!v.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Password field
                    _InputField(
                      controller: _passwordCtrl,
                      label: 'Password',
                      hint: '••••••••',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.lock_outline_rounded,
                      enabled: !isLoading,
                      onFieldSubmitted: (_) => _signIn(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.silver,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Sign in button
                    FilledButton(
                      onPressed: isLoading ? null : _signIn,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.charcoal,
                        disabledBackgroundColor: AppColors.gold.withAlpha(102),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.charcoal,
                              ),
                            )
                          : Text(
                              'Sign In',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.charcoal,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Forgot password
                    if (_resetEmailSent)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(
                          'Password reset email sent. Check your inbox.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.gold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      TextButton(
                        onPressed: isLoading ? null : _forgotPassword,
                        child: Text(
                          'Forgot password?',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.silver,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton.icon(
                      onPressed: isLoading ? null : _showCreateAccountDialog,
                      icon: const Icon(Icons.person_add_outlined, size: 18),
                      label: const Text('Create a new account'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Styled text field for the login form.
class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIcon,
    this.validator,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      enabled: enabled,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: AppColors.silver),
        hintStyle: TextStyle(color: AppColors.silver.withAlpha(120)),
        prefixIcon: Icon(prefixIcon, color: AppColors.silver, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF2E2E2E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        errorStyle: const TextStyle(color: AppColors.error),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
      ),
    );
  }
}
