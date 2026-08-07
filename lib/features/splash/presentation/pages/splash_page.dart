import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/firebase_bootstrap.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/loading_indicator.dart';

/// Splash screen — Muzammil Autos brand intro.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigateAfterDelay());
  }

  Future<void> _navigateAfterDelay() async {
    await Future<void>.delayed(AppConfig.splashDuration);
    if (!mounted) return;
    final user = FirebaseBootstrap.currentUser;
    final String target =
        user != null ? AppRoutes.dashboard : AppRoutes.login;
    context.go(target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.charcoal,
              Color(0xFF1A1A1A),
              AppColors.charcoal,
            ],
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BrandLogo(size: 160),
            SizedBox(height: 40),
            LoadingIndicator(
              color: AppColors.gold,
              size: 28,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
