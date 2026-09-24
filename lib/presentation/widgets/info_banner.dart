import 'package:flutter/material.dart';

import '../../core/theme/app_dimens.dart';
import '../../core/theme/theme_context.dart';

/// Meaning of an [InfoBanner], which picks its colors.
enum BannerTone { info, success, error }

/// A tinted note with an icon, for hints, confirmations and errors.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.message,
    this.tone = BannerTone.info,
    this.icon,
  });

  final String message;
  final BannerTone tone;

  /// Defaults to an icon matching [tone].
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    final (Color background, Color foreground, IconData defaultIcon) =
        switch (tone) {
      BannerTone.info => (
          colors.tertiaryContainer,
          colors.onTertiaryContainer,
          Icons.lightbulb_outline_rounded,
        ),
      BannerTone.success => (
          colors.secondaryContainer,
          colors.onSecondaryContainer,
          Icons.check_circle_outline_rounded,
        ),
      BannerTone.error => (
          colors.errorContainer,
          colors.onErrorContainer,
          Icons.error_outline_rounded,
        ),
    };
    return Semantics(
      liveRegion: tone == BannerTone.error,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadius.medium,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon ?? defaultIcon, size: 20, color: foreground),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  message,
                  style:
                      context.textTheme.bodyMedium?.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
