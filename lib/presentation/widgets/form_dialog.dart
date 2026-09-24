import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import 'form_error_text.dart';

/// The shell of the add/edit dialogs: a title, the form [children], an inline
/// [error] and Cancel / submit actions.
class FormDialog extends StatelessWidget {
  const FormDialog({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.onSubmit,
    required this.children,
    this.error,
  });

  final String title;
  final String submitLabel;
  final VoidCallback onSubmit;
  final List<Widget> children;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      scrollable: true,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 4),
            ...children,
            if (error != null) FormErrorText(error!),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(onPressed: onSubmit, child: Text(submitLabel)),
      ],
    );
  }
}
