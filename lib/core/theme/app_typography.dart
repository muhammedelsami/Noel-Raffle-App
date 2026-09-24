import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Font families bundled with the app.
abstract final class AppFonts {
  /// Google Fonts "Alexandria": a variable font (weights 100–900) covering
  /// Latin, Turkish and Arabic, so every locale renders with the same
  /// typeface. It is bundled rather than downloaded, so it works offline and
  /// never swaps in after the first frame.
  static const String body = 'Alexandria';

  static const String _license = 'assets/fonts/Alexandria-OFL.txt';

  /// Adds the font's SIL Open Font License to the app's license registry,
  /// as the license requires when the font is redistributed.
  static void registerLicense() {
    LicenseRegistry.addLicense(() async* {
      yield LicenseEntryWithLineBreaks(
        const <String>[body],
        await rootBundle.loadString(_license),
      );
    });
  }
}

/// The app's type scale.
///
/// Each style sets an explicit line height with even leading, so Latin and
/// Arabic text share the same rhythm and stay vertically centered.
abstract final class AppTypography {
  static TextTheme textTheme(ColorScheme scheme) {
    return TextTheme(
      displayLarge: _style(52, FontWeight.w700, 1.1, -1),
      displayMedium: _style(40, FontWeight.w700, 1.1, -0.8),
      displaySmall: _style(34, FontWeight.w700, 1.15, -0.5),
      headlineLarge: _style(30, FontWeight.w700, 1.2, -0.4),
      headlineMedium: _style(26, FontWeight.w600, 1.2, -0.3),
      headlineSmall: _style(22, FontWeight.w600, 1.25, -0.2),
      titleLarge: _style(20, FontWeight.w600, 1.3),
      titleMedium: _style(16, FontWeight.w600, 1.35),
      titleSmall: _style(14, FontWeight.w600, 1.35),
      bodyLarge: _style(16, FontWeight.w400, 1.5),
      bodyMedium: _style(14, FontWeight.w400, 1.45),
      bodySmall: _style(12, FontWeight.w400, 1.4),
      labelLarge: _style(15, FontWeight.w600, 1.25),
      labelMedium: _style(13, FontWeight.w500, 1.25),
      labelSmall: _style(11, FontWeight.w600, 1.2, 0.4),
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
