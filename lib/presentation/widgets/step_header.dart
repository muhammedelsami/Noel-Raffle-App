import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/raffle_type_style.dart';
import '../../core/theme/theme_context.dart';
import '../../domain/entities/raffle_type.dart';

/// Heading of a raffle creation step: "Step 2 of 3", a segmented progress
/// bar in the raffle type's accent color, a title and a hint.
class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.type,
    required this.step,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final RaffleType type;

  /// 1-based index of the current step.
  final int step;
  final String title;
  final String subtitle;

  /// Shown next to the title, e.g. a counter.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    final TextTheme text = context.textTheme;
    final Color accent = type.accentColors(colors).accent;
    final int total = type.stepCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          context.l10n.stepProgress(step, total),
          style: text.labelMedium?.copyWith(color: accent),
        ),
        const SizedBox(height: AppSpacing.sm),
        ExcludeSemantics(
          child: Row(
            children: <Widget>[
              for (int i = 1; i <= total; i++) ...<Widget>[
                if (i > 1) const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color:
                          i <= step ? accent : colors.surfaceContainerHighest,
                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: <Widget>[
            Expanded(
              child: Semantics(
                header: true,
                child: Text(title, style: text.headlineSmall),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
