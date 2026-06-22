import 'package:flutter/material.dart';

/// Brand palette derived from the original Noel Raffle identity.
abstract final class AppColors {
  // Core brand reds (kept from the legacy design).
  static const Color brandRed = Color(0xFFEE1919);
  static const Color brandRedDark = Color(0xFF720303);
  static const Color brandRedSoft = Color(0xFFFF6D6D);
  static const Color accentBlue = Color(0xFF6A84BF);

  // Neutral scrim tones used over the festive background image.
  static const Color scrimLight = Color(0x33000000);
  static const Color scrimDark = Color(0xCC120203);

  /// Light Material 3 color scheme seeded from the brand red.
  static final ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: brandRed,
    primary: brandRed,
    secondary: accentBlue,
  );

  /// Dark Material 3 color scheme seeded from the brand red.
  static final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: brandRed,
    brightness: Brightness.dark,
    primary: brandRedSoft,
    secondary: accentBlue,
  );
}
