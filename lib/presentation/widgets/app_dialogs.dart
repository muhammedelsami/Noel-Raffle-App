import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';

/// Shows the shared warning alert with a single OK action.
Future<void> showWarningDialog(BuildContext context, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      icon: const Icon(Icons.info_outline_rounded),
      title: Text(context.l10n.warning),
      content: Text(message, textAlign: TextAlign.center),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.ok),
        ),
      ],
    ),
  );
}

/// Asks the user to confirm an action; resolves to `true` only when
/// [confirmLabel] is tapped. A [destructive] action gets an error-colored
/// confirm button.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  IconData? icon,
  bool destructive = false,
}) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      final ColorScheme colors = Theme.of(context).colorScheme;
      return AlertDialog(
        icon: icon == null ? null : Icon(icon),
        iconColor: destructive ? colors.error : null,
        title: Text(title, textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            style: destructive
                ? FilledButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: colors.onError,
                  )
                : null,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
