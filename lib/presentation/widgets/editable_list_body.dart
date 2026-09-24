import 'package:flutter/material.dart';

import '../../core/theme/app_dimens.dart';
import 'empty_state.dart';

/// Body of the participant and gift steps: a [header], an optional [notice],
/// an [addButton] and the list, or an empty state while the list is empty.
/// Only the visible rows are built.
class EditableListBody extends StatelessWidget {
  const EditableListBody({
    super.key,
    required this.header,
    required this.addButton,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.itemCount,
    required this.itemBuilder,
    this.notice,
  });

  final Widget header;
  final Widget addButton;
  final IconData emptyIcon;
  final String emptyTitle;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// Shown between the header and the add button, e.g. a rule warning.
  final Widget? notice;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.sm,
            AppSpacing.page,
            AppSpacing.md,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                header,
                const SizedBox(height: AppSpacing.lg),
                if (notice != null) ...<Widget>[
                  notice!,
                  const SizedBox(height: AppSpacing.md),
                ],
                addButton,
              ],
            ),
          ),
        ),
        if (itemCount == 0)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(icon: emptyIcon, title: emptyTitle),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              0,
              AppSpacing.page,
              AppSpacing.xl,
            ),
            sliver: SliverList.separated(
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
            ),
          ),
      ],
    );
  }
}
