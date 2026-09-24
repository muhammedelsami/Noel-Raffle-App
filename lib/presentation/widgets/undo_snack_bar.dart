import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';

/// Tells the user that [name] was removed and offers to bring it back.
/// Replaces any snack bar that is still showing.
void showUndoSnackBar(
  BuildContext context, {
  required String name,
  required VoidCallback onUndo,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(context.l10n.removedItem(name)),
        action: SnackBarAction(label: context.l10n.undo, onPressed: onUndo),
      ),
    );
}
