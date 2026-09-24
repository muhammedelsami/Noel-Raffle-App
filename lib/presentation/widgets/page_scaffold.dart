import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_dimens.dart';

/// The standard page: an app bar, a width-limited body and an optional
/// [bottomBar] of actions.
///
/// The bottom bar sits in `Scaffold.bottomNavigationBar`, so snack bars float
/// above it, and is lifted by the keyboard height so it stays visible while
/// typing.
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
        child: ContentWidth(child: body),
      ),
      bottomNavigationBar: bottomBar == null
          ? null
          : Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: BottomActionBar(child: bottomBar),
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
    // Only as tall as the child, so it doesn't stretch to fill loose slots
    // such as the scaffold's bottom bar.
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
