import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/l10n_extensions.dart';

/// Shows the shared warning alert with a single OK action.
Future<void> showWarningDialog(BuildContext context, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      insetPadding: AppConstants.dialogInset,
      title: Text(context.l10n.warning, textAlign: TextAlign.center),
      content: SizedBox(
        width: double.maxFinite,
        child: Text(message, textAlign: TextAlign.center),
      ),
      actionsAlignment: MainAxisAlignment.center,
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
/// [confirmLabel] is tapped.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      insetPadding: AppConstants.dialogInset,
      title: Text(title, textAlign: TextAlign.center),
      content: SizedBox(
        width: double.maxFinite,
        child: Text(message, textAlign: TextAlign.center),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
