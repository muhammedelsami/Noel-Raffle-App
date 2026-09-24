import 'package:flutter/material.dart';

import '../../core/theme/app_dimens.dart';
import '../../core/theme/theme_context.dart';

/// Small heading above a group of cards or list rows.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: AppSpacing.xs,
        top: AppSpacing.xl,
        bottom: AppSpacing.sm,
      ),
      child: Semantics(
        header: true,
        child: Text(
          title,
          style: context.textTheme.titleSmall
              ?.copyWith(color: context.colors.onSurfaceVariant),
        ),
      ),
    );
  }
}
