import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/participant.dart';
import 'app_text_field.dart';
import 'form_error_text.dart';
import 'primary_button.dart';

/// Shows the add/edit participant form and resolves to the saved
/// [Participant], or `null` if dismissed.
///
/// [isDuplicate] is asked before saving so the same name cannot be added
/// twice (the participant being edited is excluded by the caller).
Future<Participant?> showParticipantForm(
  BuildContext context, {
  Participant? initial,
  required bool Function(String name) isDuplicate,
}) {
  return showDialog<Participant>(
    context: context,
    builder: (_) =>
        _ParticipantForm(initial: initial, isDuplicate: isDuplicate),
  );
}

class _ParticipantForm extends StatefulWidget {
  const _ParticipantForm({this.initial, required this.isDuplicate});

  final Participant? initial;
  final bool Function(String name) isDuplicate;

  @override
  State<_ParticipantForm> createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<_ParticipantForm> {
  late final TextEditingController _name =
      TextEditingController(text: widget.initial?.name);
  late final TextEditingController _email =
      TextEditingController(text: widget.initial?.email);

  final FocusNode _emailFocus = FocusNode();

  /// Validation message shown inside the dialog. A SnackBar would outlive the
  /// dialog and cover the buttons of the screen below.
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final String name = _name.text.trim();
    final String email = _email.text.trim();

    if (!Validators.isNotBlank(name)) {
      _showError(context.l10n.nameRequired);
      return;
    }
    if (!Validators.isValidOptionalEmail(email)) {
      _showError(context.l10n.invalidEmail);
      return;
    }
    if (widget.isDuplicate(name)) {
      _showError(context.l10n.nameAlreadyAdded);
      return;
    }
    Navigator.of(context).pop(
      Participant(name: name, email: email.isEmpty ? null : email),
    );
  }

  void _showError(String message) => setState(() => _error = message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: AppConstants.dialogInset,
      title: Text(context.l10n.newParticipant, textAlign: TextAlign.center),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppTextField(
                controller: _name,
                label: context.l10n.name,
                autofocus: true,
                maxLength: AppConstants.maxNameLength,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _emailFocus.requestFocus(),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _email,
                label: context.l10n.emailOptional,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              if (_error != null) FormErrorText(_error!),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            label:
                widget.initial == null ? context.l10n.add : context.l10n.save,
            onPressed: _submit,
          ),
        ),
      ],
    );
  }
}
