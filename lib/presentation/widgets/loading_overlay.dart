import 'package:flutter/material.dart';

import '../../core/theme/app_dimens.dart';

/// Dims the screen and shows a spinner over [child] while [isLoading] is
/// true, blocking input so an action cannot be triggered twice.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Stack(
      children: <Widget>[
        child,
        if (isLoading) ...<Widget>[
          ModalBarrier(
            dismissible: false,
            color: colors.scrim.withValues(alpha: 0.32),
          ),
          const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
