import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';

/// Festive background image with a theme-aware veil.
///
/// The veil is tinted with the current surface color, so foreground text using
/// `onSurface` stays readable in both light and dark modes while the brand
/// artwork still shows through.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Color surface = Theme.of(context).colorScheme.surface;
    // SizedBox.expand forces the background to fill the whole body, even when
    // the foreground content is shorter than the viewport.
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.background),
            fit: BoxFit.cover,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                surface.withValues(alpha: 0.55),
                surface.withValues(alpha: 0.82),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
