import 'package:flutter/material.dart';

import '../../core/theme/brand_colors.dart';
import '../../core/theme/theme_context.dart';

/// A circle with a person's initials. The color is derived from the name, so
/// each person keeps the same color everywhere. Decorative: the name itself
/// is announced by the surrounding tile.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar(this.name, {super.key, this.size = 40});

  final String name;
  final double size;

  /// First letters of the first and last word, e.g. "Ayşe Nur Kaya" → "AK".
  static String initialsOf(String name) {
    final List<String> words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    final String first = words.first.characters.first;
    final String last = words.length > 1 ? words.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPair pair = context.brand.avatarColorsFor(name);
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: pair.background,
          shape: BoxShape.circle,
        ),
        child: Text(
          initialsOf(name),
          maxLines: 1,
          style: context.textTheme.labelLarge?.copyWith(
            color: pair.foreground,
            fontSize: size * 0.38,
          ),
        ),
      ),
    );
  }
}
