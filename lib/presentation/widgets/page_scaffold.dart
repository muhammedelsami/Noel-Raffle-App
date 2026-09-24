import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_dimens.dart';

/// The standard page: an app bar, a width-limited body and an optional
/// [bottomBar] of actions.
///
/// The bottom bar is laid out below the body rather than in
/// `Scaffold.bottomNavigationBar`, so it stays visible above the keyboard.
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.bottomBar,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final Widget? bottomBar = this.bottomBar;
    return Scaffold(
      appBar: AppBar(
        title: title == null ? null : Text(title!),
        actions: actions,
      ),
      body: SafeArea(
        top: false,
        bottom: bottomBar == null,
        child: Column(
          children: <Widget>[
            Expanded(child: ContentWidth(child: body)),
            if (bottomBar != null) BottomActionBar(child: bottomBar),
          ],
        ),
      ),
    );
  }
}

/// Pins actions to the bottom of a page, above the system navigation bar.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.md,
          AppSpacing.page,
          AppSpacing.lg,
        ),
        child: ContentWidth(child: child),
      ),
    );
  }
}

/// Centers [child] and gives it the full width, up to
/// [AppConstants.maxContentWidth].
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
