import 'package:flutter/material.dart';

import '../../core/theme/app_dimens.dart';

/// Cards side by side, equally wide and as tall as the tallest one.
class EqualHeightRow extends StatelessWidget {
  const EqualHeightRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            Expanded(child: children[i]),
          ],
        ],
      ),
    );
  }
}
