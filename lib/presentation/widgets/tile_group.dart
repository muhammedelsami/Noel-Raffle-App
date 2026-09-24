import 'package:flutter/material.dart';

import '../../core/theme/app_dimens.dart';

/// List tiles on one card, separated by inset dividers. The card clips the
/// ink, so the tiles themselves are square.
class TileGroup extends StatelessWidget {
  const TileGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTileTheme.merge(
        shape: const RoundedRectangleBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          children: <Widget>[
            for (int i = 0; i < children.length; i++) ...<Widget>[
              if (i > 0) const Divider(indent: AppSpacing.lg),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}
