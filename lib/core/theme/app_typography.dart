import 'package:flutter/material.dart';

/// Font families bundled with the app.
abstract final class AppFonts {
  /// Variable font (weights 200–1000) covering Latin, Turkish and Arabic, so
  /// every locale renders with the same typeface.
  static const String body = 'Cairo';
}

/// The app's type scale.
///
/// Cairo has tall ascenders for Arabic, so each style sets an explicit line
/// height with even leading to keep Latin text vertically centered.
abstract final class AppTypography {
  static TextTheme textTheme(ColorScheme scheme) {
    return TextTheme(
      displayLarge: _style(52, FontWeight.w800, 1.1, -1),
      displayMedium: _style(40, FontWeight.w800, 1.1, -0.8),
      displaySmall: _style(34, FontWeight.w800, 1.15, -0.5),
      headlineLarge: _style(30, FontWeight.w800, 1.2, -0.4),
      headlineMedium: _style(26, FontWeight.w700, 1.2, -0.3),
      headlineSmall: _style(22, FontWeight.w700, 1.25, -0.2),
      titleLarge: _style(20, FontWeight.w700, 1.3),
      titleMedium: _style(16, FontWeight.w700, 1.35),
      titleSmall: _style(14, FontWeight.w700, 1.35),
      bodyLarge: _style(16, FontWeight.w400, 1.5),
      bodyMedium: _style(14, FontWeight.w400, 1.45),
      bodySmall: _style(12, FontWeight.w500, 1.4),
      labelLarge: _style(15, FontWeight.w700, 1.25),
      labelMedium: _style(13, FontWeight.w600, 1.25),
      labelSmall: _style(11, FontWeight.w700, 1.2, 0.4),
    ).apply(
      fontFamily: AppFonts.body,
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
  }

  static TextStyle _style(
    double size,
    FontWeight weight,
    double height, [
    double letterSpacing = 0,
  ]) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }
}
