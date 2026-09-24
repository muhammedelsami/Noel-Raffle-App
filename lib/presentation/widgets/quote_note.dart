import 'package:flutter/material.dart';

import '../../core/theme/app_dimens.dart';
import '../../core/theme/theme_context.dart';

/// The organizer's note to the participants, set off with a quote mark.
class QuoteNote extends StatelessWidget {
  const QuoteNote(this.note, {super.key});

  final String note;

  @override
  Widget build(BuildContext context) {
    final Color muted = context.colors.onSurfaceVariant;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(Icons.format_quote_rounded, size: 20, color: muted),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            note,
            style: context.textTheme.bodyMedium?.copyWith(color: muted),
          ),
        ),
      ],
    );
  }
}
