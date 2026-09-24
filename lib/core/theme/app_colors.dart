import 'package:flutter/material.dart';

/// The Noel Raffle palette: cranberry red, evergreen and gold over warm
/// neutrals.
///
/// Both schemes are hand-tuned instead of seeded, so every text/background
/// pair (including `primary` text on `surface`) meets WCAG AA contrast.
abstract final class AppColors {
  // Brand tones used outside the color schemes (hero gradient, app mark).
  static const Color cranberry = Color(0xFFC8243A);
  static const Color cranberryDeep = Color(0xFF8C1026);
  static const Color wine = Color(0xFF5E0B1C);
  static const Color gold = Color(0xFFF2BE5C);
  static const Color snow = Color(0xFFFFFFFF);

  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFB3192C),
    onPrimary: snow,
    primaryContainer: Color(0xFFFFE3E4),
    onPrimaryContainer: Color(0xFF5C0714),
    secondary: Color(0xFF0E6B4F),
    onSecondary: snow,
    secondaryContainer: Color(0xFFD4F1E4),
    onSecondaryContainer: Color(0xFF063D2C),
    tertiary: Color(0xFF8F5A00),
    onTertiary: snow,
    tertiaryContainer: Color(0xFFFFE7B5),
    onTertiaryContainer: Color(0xFF4A2E00),
    error: Color(0xFFBA1A1A),
    onError: snow,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFBF8F7),
    onSurface: Color(0xFF1C1A1D),
    onSurfaceVariant: Color(0xFF5F5A60),
    surfaceDim: Color(0xFFDDD8D7),
    surfaceBright: Color(0xFFFBF8F7),
    surfaceContainerLowest: snow,
    surfaceContainerLow: Color(0xFFF6F2F1),
    surfaceContainer: Color(0xFFF1ECEB),
    surfaceContainerHigh: Color(0xFFEDE8E7),
    surfaceContainerHighest: Color(0xFFE7E1E0),
    outline: Color(0xFF8A8388),
    outlineVariant: Color(0xFFE4DDDC),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF312F32),
    onInverseSurface: Color(0xFFF4EFEE),
    inversePrimary: Color(0xFFFF6B78),
    surfaceTint: Color(0xFFB3192C),
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFF6B78),
    onPrimary: Color(0xFF3D000B),
    primaryContainer: Color(0xFF5B1320),
    onPrimaryContainer: Color(0xFFFFD9DB),
    secondary: Color(0xFF6FD6A8),
    onSecondary: Color(0xFF003826),
    secondaryContainer: Color(0xFF0D4A36),
    onSecondaryContainer: Color(0xFFC9F2DE),
    tertiary: Color(0xFFF2BE5C),
    onTertiary: Color(0xFF452B00),
    tertiaryContainer: Color(0xFF5A3C00),
    onTertiaryContainer: Color(0xFFFFE3AE),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF5F1A17),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF121014),
    onSurface: Color(0xFFECE7EA),
    onSurfaceVariant: Color(0xFFB3ACB2),
    surfaceDim: Color(0xFF121014),
    surfaceBright: Color(0xFF39363B),
    surfaceContainerLowest: Color(0xFF0D0B0F),
    surfaceContainerLow: Color(0xFF1A181C),
    surfaceContainer: Color(0xFF1F1C21),
    surfaceContainerHigh: Color(0xFF2A272C),
    surfaceContainerHighest: Color(0xFF353237),
    outline: Color(0xFF7D767C),
    outlineVariant: Color(0xFF38343A),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFECE7EA),
    onInverseSurface: Color(0xFF312F32),
    inversePrimary: Color(0xFFB3192C),
    surfaceTint: Color(0xFFFF6B78),
  );
}
