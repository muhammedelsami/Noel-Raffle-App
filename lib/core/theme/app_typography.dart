import 'package:flutter/material.dart';

/// Font families bundled with the app.
abstract final class AppFonts {
  static const String display = 'DancingScript';
  static const String accent = 'MountainsofChristmas';
  static const String body = 'Cairo';
}

/// Builds a [TextTheme] for the given [ColorScheme] using the brand fonts.
abstract final class AppTypography {
  static TextTheme textTheme(ColorScheme scheme) {
    final Color onBg = scheme.onSurface;
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: AppFonts.display,
        fontSize: 44,
        fontWeight: FontWeight.bold,
        color: onBg,
      ),
      displayMedium: TextStyle(
        fontFamily: AppFonts.display,
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: onBg,
      ),
      headlineMedium: TextStyle(
        fontFamily: AppFonts.display,
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: onBg,
      ),
      titleLarge: TextStyle(
        fontFamily: AppFonts.body,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: onBg,
      ),
      titleMedium: TextStyle(
        fontFamily: AppFonts.body,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onBg,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppFonts.body,
        fontSize: 16,
        color: onBg,
        height: 1.4,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppFonts.body,
        fontSize: 14,
        color: onBg,
        height: 1.4,
      ),
      labelLarge: const TextStyle(
        fontFamily: AppFonts.body,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
