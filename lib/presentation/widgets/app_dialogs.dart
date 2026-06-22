import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';

/// Shows the shared "Uyarı" alert with a single OK action.
Future<void> showWarningDialog(BuildContext context, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      insetPadding: AppConstants.dialogInset,
      title: const Text(AppStrings.warning, textAlign: TextAlign.center),
      content: SizedBox(
        width: double.maxFinite,
        child: Text(message, textAlign: TextAlign.center),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.ok),
        ),
      ],
    ),
  );
}
