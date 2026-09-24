import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../domain/entities/raffle_type.dart';

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
    final TextTheme text = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String? match = this.match;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          type.isNewYear ? Icons.redeem_rounded : Icons.card_giftcard_rounded,
          size: 56,
          color: scheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.greeting(participantName),
          textAlign: TextAlign.center,
          style: text.headlineMedium,
        ),
        const SizedBox(height: 16),
        if (match == null)
          Text(
            context.l10n.noPrize,
            textAlign: TextAlign.center,
            style: text.titleMedium,
          )
        else ...<Widget>[
          Text(
            type.isNewYear ? context.l10n.yourGiftee : context.l10n.yourPrize,
            textAlign: TextAlign.center,
            style: text.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            match,
            textAlign: TextAlign.center,
            style: text.displayMedium?.copyWith(color: scheme.primary),
          ),
        ],
        if (note.isNotEmpty) ...<Widget>[
          const SizedBox(height: 16),
          Text(
            note,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ],
    );
  }
}
