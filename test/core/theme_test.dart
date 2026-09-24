import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/core/theme/app_theme.dart';
import 'package:noel_raffle/core/theme/brand_colors.dart';

/// WCAG contrast ratio between two opaque colors.
double contrast(Color a, Color b) {
  final double la = a.computeLuminance();
  final double lb = b.computeLuminance();
  final double hi = la > lb ? la : lb;
  final double lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  for (final (String name, ThemeData theme) in <(String, ThemeData)>[
    ('light', AppTheme.light),
    ('dark', AppTheme.dark),
  ]) {
    group('$name theme', () {
      final ColorScheme c = theme.colorScheme;

      test('text colors meet WCAG AA (4.5:1)', () {
        final Map<String, (Color, Color)> pairs = <String, (Color, Color)>{
          'onSurface': (c.onSurface, c.surface),
          'onSurfaceVariant': (c.onSurfaceVariant, c.surface),
          'onSurfaceVariant on card': (
            c.onSurfaceVariant,
            theme.cardTheme.color!,
          ),
          'primary text': (c.primary, c.surface),
          'onPrimary': (c.onPrimary, c.primary),
          'onPrimaryContainer': (c.onPrimaryContainer, c.primaryContainer),
          'onSecondary': (c.onSecondary, c.secondary),
          'onSecondaryContainer': (
            c.onSecondaryContainer,
            c.secondaryContainer,
          ),
          'onTertiaryContainer': (c.onTertiaryContainer, c.tertiaryContainer),
          'onErrorContainer': (c.onErrorContainer, c.errorContainer),
          'error text': (c.error, c.surface),
        };
        pairs.forEach((String label, (Color, Color) pair) {
          expect(
            contrast(pair.$1, pair.$2),
            greaterThanOrEqualTo(4.5),
            reason: label,
          );
        });
      });

      test('provides brand colors with accessible avatars', () {
        final BrandColors brand = theme.extension<BrandColors>()!;
        expect(contrast(brand.onHero, brand.heroGradient.colors.first),
            greaterThanOrEqualTo(4.5));
        for (final ColorPair pair in brand.avatarColors) {
          expect(
            contrast(pair.foreground, pair.background),
            greaterThanOrEqualTo(4.5),
          );
        }
      });
    });
  }

  test('themes are built once and reused', () {
    expect(identical(AppTheme.light, AppTheme.light), isTrue);
    expect(identical(AppTheme.dark, AppTheme.dark), isTrue);
  });

  test('avatar colors are stable and ignore case', () {
    const BrandColors brand = BrandColors.light;
    expect(brand.avatarColorsFor('Ayşe'), brand.avatarColorsFor('ayşe'));
    expect(brand.avatarColorsFor('Burak'), brand.avatarColorsFor('Burak'));
  });
}
