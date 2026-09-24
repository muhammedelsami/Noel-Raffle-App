import 'package:flutter/material.dart';

import '../../core/theme/app_dimens.dart';
import '../../core/theme/theme_context.dart';

/// A small rounded label, optionally with a leading icon, e.g. a raffle type
/// or a result status.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.icon,
    this.background,
    this.foreground,
  });

  final String label;
  final IconData? icon;

  /// Defaults to `surfaceContainerHigh`.
  final Color? background;

  /// Defaults to `onSurfaceVariant`.
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    final Color foreground = this.foreground ?? colors.onSurfaceVariant;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background ?? colors.surfaceContainerHigh,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, size: 14, color: foreground),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    context.textTheme.labelMedium?.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A [StatusPill] for a running count that turns green with a check mark
/// once the count is [complete], e.g. enough participants were added.
class CountPill extends StatelessWidget {
  const CountPill({
    super.key,
    required this.label,
    required this.icon,
    this.complete = false,
  });

  final String label;
  final IconData icon;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    return StatusPill(
      label: label,
      icon: complete ? Icons.check_circle_rounded : icon,
      background: complete ? colors.secondaryContainer : null,
      foreground: complete ? colors.onSecondaryContainer : null,
    );
  }
}
