import 'package:flutter/material.dart';

import 'brand_colors.dart';

/// Shorthands for the active theme, e.g. `context.colors.primary`.
extension ThemeContextX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  BrandColors get brand => Theme.of(this).extension<BrandColors>()!;
}
