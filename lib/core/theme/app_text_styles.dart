import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Muzammil Autos typography — Inter across the app.
class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get _base => GoogleFonts.inter();

  static TextStyle displayLarge = _base.copyWith(
    fontSize: 57,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static TextStyle displayMedium = _base.copyWith(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    height: 1.16,
  );

  static TextStyle displaySmall = _base.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 1.22,
  );

  static TextStyle headlineLarge = _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static TextStyle headlineMedium = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.29,
  );

  static TextStyle headlineSmall = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33,
  );

  static TextStyle titleLarge = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
  );

  static TextStyle titleMedium = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static TextStyle titleSmall = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static TextStyle bodyLarge = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static TextStyle bodyMedium = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.43,
  );

  static TextStyle bodySmall = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.33,
  );

  static TextStyle labelLarge = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static TextStyle labelMedium = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static TextStyle labelSmall = _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.45,
  );

  static TextTheme textTheme({required bool isDark}) {
    final Color onSurface =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;

    return TextTheme(
      displayLarge: displayLarge.copyWith(color: onSurface),
      displayMedium: displayMedium.copyWith(color: onSurface),
      displaySmall: displaySmall.copyWith(color: onSurface),
      headlineLarge: headlineLarge.copyWith(color: onSurface),
      headlineMedium: headlineMedium.copyWith(color: onSurface),
      headlineSmall: headlineSmall.copyWith(color: onSurface),
      titleLarge: titleLarge.copyWith(color: onSurface),
      titleMedium: titleMedium.copyWith(color: onSurface),
      titleSmall: titleSmall.copyWith(color: onSurface),
      bodyLarge: bodyLarge.copyWith(color: onSurface),
      bodyMedium: bodyMedium.copyWith(color: onSurface),
      bodySmall: bodySmall.copyWith(
        color: isDark ? AppColors.silver : AppColors.grey600,
      ),
      labelLarge: labelLarge.copyWith(color: onSurface),
      labelMedium: labelMedium.copyWith(color: onSurface),
      labelSmall: labelSmall.copyWith(
        color: isDark ? AppColors.silver : AppColors.grey600,
      ),
    );
  }
}
