import 'package:flutter/material.dart';

/// An icon on a tinted rounded square (or circle), used as a list leading,
/// a stat icon or an empty-state glyph.
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    this.background,
    this.foreground,
    this.size = 40,
    this.circle = false,
  });

  final IconData icon;

  /// Defaults to `primaryContainer`.
  final Color? background;

  /// Defaults to `onPrimaryContainer`.
  final Color? foreground;
  final double size;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? colors.primaryContainer,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius:
            circle ? null : BorderRadius.all(Radius.circular(size * 0.3)),
      ),
      child: Icon(
        icon,
        size: size * 0.5,
        color: foreground ?? colors.onPrimaryContainer,
      ),
    );
  }
}
