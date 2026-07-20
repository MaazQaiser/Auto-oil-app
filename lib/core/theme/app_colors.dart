import 'package:flutter/material.dart';

/// Muzammil Autos brand palette — Charcoal, Gold, Silver, White.
class AppColors {
  const AppColors._();

  // Brand (from Brand Identity Kit)
  static const Color charcoal = Color(0xFF222222);
  static const Color gold = Color(0xFFDAA520);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color beige = Color(0xFFE8DFD0);

  /// Primary accent — Gold
  static const Color primary = gold;
  static const Color primaryLight = Color(0xFFE8C252);
  static const Color primaryDark = Color(0xFFB8860B);

  /// Secondary accent — Silver
  static const Color secondary = silver;
  static const Color secondaryLight = Color(0xFFD8D8D8);
  static const Color secondaryDark = Color(0xFF9E9E9E);

  // Semantic (tuned to sit with gold/charcoal UI)
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF5C7C9C);

  // Neutrals
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = charcoal;

  // Light theme surfaces — white content under charcoal chrome
  static const Color lightBackground = Color(0xFFF7F7F7);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = charcoal;
  static const Color lightOnBackground = charcoal;
  static const Color lightCardShadow = Color(0x1A000000);

  // Dark theme surfaces — charcoal family
  static const Color darkBackground = Color(0xFF141414);
  static const Color darkSurface = charcoal;
  static const Color darkOnSurface = Color(0xFFF5F5F5);
  static const Color darkOnBackground = Color(0xFFF5F5F5);
  static const Color darkCardShadow = Color(0x40000000);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  /// On-primary for gold buttons (white per brand kit CTAs).
  static const Color onPrimary = white;
}
