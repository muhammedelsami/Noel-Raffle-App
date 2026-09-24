import 'package:flutter/material.dart';

import '../../core/theme/app_dimens.dart';
import '../../core/theme/theme_context.dart';

/// A secondary piece of text set off with an [icon], such as the organizer's
/// note or someone's gift ideas, with an optional [label] above it.
class NoteLine extends StatelessWidget {
  const NoteLine(
    this.text, {
    super.key,
    this.icon = Icons.format_quote_rounded,
    this.label,
  });

  final String text;
  final IconData icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final Color muted = context.colors.onSurfaceVariant;
    final TextTheme theme = context.textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20, color: muted),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (label != null)
                Text(label!, style: theme.labelMedium?.copyWith(color: muted)),
              Text(text, style: theme.bodyMedium?.copyWith(color: muted)),
            ],
          ),
        ),
      ],
    );
  }
}
