import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/raffle_type_style.dart';
import '../../core/theme/theme_context.dart';
import '../../domain/entities/raffle_type.dart';
import 'icon_badge.dart';
import 'quote_note.dart';

/// A participant's own result: who they buy a gift for, or which gift they
/// won. Used when revealing results on the device and after an online lookup.
class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.type,
    required this.participantName,
    this.match,
    this.note = '',
  });

  final RaffleType type;
  final String participantName;

  /// See `DrawAssignment.match`.
  final String? match;
  final String note;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = context.textTheme;
    final ColorScheme colors = context.colors;
    final AccentColors accent = type.accentColors(colors);
    final String? match = this.match;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: IconBadge(
            icon: match == null ? Icons.sentiment_satisfied_rounded : type.icon,
            size: 64,
            circle: true,
            background: accent.container,
            foreground: accent.onContainer,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          context.l10n.greeting(participantName),
          textAlign: TextAlign.center,
          style: text.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (match == null)
          Text(
            context.l10n.noPrize,
            textAlign: TextAlign.center,
            style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
          )
        else
          DecoratedBox(
            decoration: BoxDecoration(
              color: accent.container,
              borderRadius: AppRadius.large,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: <Widget>[
                  Text(
                    type.isNewYear
                        ? context.l10n.yourGiftee
                        : context.l10n.yourPrize,
                    textAlign: TextAlign.center,
                    style: text.labelLarge?.copyWith(color: accent.onContainer),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    match,
                    textAlign: TextAlign.center,
                    style:
                        text.headlineLarge?.copyWith(color: accent.onContainer),
                  ),
                ],
              ),
            ),
          ),
        if (note.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          QuoteNote(note),
        ],
      ],
    );
  }
}
