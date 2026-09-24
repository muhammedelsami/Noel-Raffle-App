import 'package:flutter/material.dart';

import 'app_colors.dart';

/// A background/foreground pair, e.g. for an initials avatar.
typedef ColorPair = ({Color background, Color foreground});

/// Brand colors that have no [ColorScheme] role, with light and dark
/// variants. Read them with `context.brand`.
@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  const BrandColors({
    required this.heroGradient,
    required this.onHero,
    required this.heroAccent,
    required this.cardBorder,
    required this.avatarColors,
  });

  static const BrandColors light = BrandColors(
    heroGradient: LinearGradient(
      begin: AlignmentDirectional.topStart,
      end: AlignmentDirectional.bottomEnd,
      colors: <Color>[AppColors.cranberry, AppColors.cranberryDeep],
    ),
    onHero: AppColors.snow,
    heroAccent: AppColors.gold,
    cardBorder: Color(0xFFEAE4E3),
    avatarColors: <ColorPair>[
      (background: Color(0xFFFFE3E4), foreground: Color(0xFF5C0714)),
      (background: Color(0xFFD4F1E4), foreground: Color(0xFF063D2C)),
      (background: Color(0xFFFFE7B5), foreground: Color(0xFF4A2E00)),
      (background: Color(0xFFDCE6FF), foreground: Color(0xFF0E2F66)),
      (background: Color(0xFFEDE0FF), foreground: Color(0xFF35175F)),
      (background: Color(0xFFCCF0F2), foreground: Color(0xFF003B40)),
    ],
  );

  static const BrandColors dark = BrandColors(
    heroGradient: LinearGradient(
      begin: AlignmentDirectional.topStart,
      end: AlignmentDirectional.bottomEnd,
      colors: <Color>[AppColors.cranberryDeep, AppColors.wine],
    ),
    onHero: AppColors.snow,
    heroAccent: AppColors.gold,
    cardBorder: Color(0xFF2E2B30),
    avatarColors: <ColorPair>[
      (background: Color(0xFF5B1320), foreground: Color(0xFFFFD9DB)),
      (background: Color(0xFF0D4A36), foreground: Color(0xFFC9F2DE)),
      (background: Color(0xFF5A3C00), foreground: Color(0xFFFFE3AE)),
      (background: Color(0xFF1C3A73), foreground: Color(0xFFDCE6FF)),
      (background: Color(0xFF43266F), foreground: Color(0xFFEDE0FF)),
      (background: Color(0xFF00474D), foreground: Color(0xFFC4F1F4)),
    ],
  );

  /// Festive gradient behind the splash and hero surfaces.
  final LinearGradient heroGradient;

  /// Text and icons on [heroGradient].
  final Color onHero;

  /// Highlights (sparkles, ribbon) on [heroGradient].
  final Color heroAccent;

  /// Hairline border around cards.
  final Color cardBorder;

  /// Distinct, accessible pairs for initials avatars.
  final List<ColorPair> avatarColors;

  /// A stable color pair for [key], so a name keeps its color across builds.
  ColorPair avatarColorsFor(String key) {
    int hash = 0;
    for (final int unit in key.toLowerCase().codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return avatarColors[hash % avatarColors.length];
  }

  @override
  BrandColors copyWith({
    LinearGradient? heroGradient,
    Color? onHero,
    Color? heroAccent,
    Color? cardBorder,
    List<ColorPair>? avatarColors,
  }) {
    return BrandColors(
      heroGradient: heroGradient ?? this.heroGradient,
      onHero: onHero ?? this.onHero,
      heroAccent: heroAccent ?? this.heroAccent,
      cardBorder: cardBorder ?? this.cardBorder,
      avatarColors: avatarColors ?? this.avatarColors,
    );
  }

  @override
  BrandColors lerp(BrandColors? other, double t) {
    if (other == null) return this;
    return BrandColors(
      heroGradient: LinearGradient.lerp(heroGradient, other.heroGradient, t)!,
      onHero: Color.lerp(onHero, other.onHero, t)!,
      heroAccent: Color.lerp(heroAccent, other.heroAccent, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      avatarColors: t < 0.5 ? avatarColors : other.avatarColors,
    );
  }
}
