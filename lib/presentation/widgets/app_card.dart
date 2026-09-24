import 'package:flutter/material.dart';

import '../../core/theme/app_dimens.dart';

/// A rounded surface that groups related content. Shape, color and border
/// come from the theme's `cardTheme`; a custom [color] drops the border so
/// tinted cards look flat.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content = Padding(padding: padding, child: child);
    return Card(
      color: color,
      shape: color == null
          ? null
          : const RoundedRectangleBorder(borderRadius: AppRadius.large),
      child: onTap == null
          ? content
          : Semantics(
              button: true,
              child: InkWell(onTap: onTap, child: content),
            ),
    );
  }
}
