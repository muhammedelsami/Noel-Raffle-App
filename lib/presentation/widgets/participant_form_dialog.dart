import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/participant.dart';
import 'app_text_field.dart';
import 'primary_button.dart';

/// Shows the add/edit participant form and resolves to the saved
/// [Participant], or `null` if dismissed.
///
/// [isDuplicate] is asked before saving so the same email cannot be added
/// twice (the participant being edited is excluded by the caller).
Future<Participant?> showParticipantForm(
  BuildContext context, {
  Participant? initial,
  required bool Function(String email) isDuplicate,
}) {
  return showDialog<Participant>(
    context: context,
    builder: (_) => _ParticipantForm(initial: initial, isDuplicate: isDuplicate),
  );
}

class _ParticipantForm extends StatefulWidget {
  const _ParticipantForm({this.initial, required this.isDuplicate});

  final Participant? initial;
  final bool Function(String email) isDuplicate;

  @override
  State<_ParticipantForm> createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<_ParticipantForm> {
  late final TextEditingController _name =
      TextEditingController(text: widget.initial?.name);
  late final TextEditingController _surname =
      TextEditingController(text: widget.initial?.surname);
  late final TextEditingController _email =
      TextEditingController(text: widget.initial?.email);

  final FocusNode _surnameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _email.dispose();
    _surnameFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final String name = _name.text.trim();
    final String surname = _surname.text.trim();
    final String email = _email.text.trim();

    if (!Validators.isNotBlank(name) ||
        !Validators.isNotBlank(surname) ||
        !Validators.isValidEmail(email)) {
      _showError(context.l10n.allFieldsRequired);
      return;
    }
    if (widget.isDuplicate(email)) {
      _showError(context.l10n.emailAlreadyAdded);
      return;
    }
    Navigator.of(context)
        .pop(Participant(name: name, surname: surname, email: email));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: AppConstants.dialogInset,
      title:
          Text(context.l10n.newParticipant, textAlign: TextAlign.center),
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
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => _surnameFocus.requestFocus(),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _surname,
              label: context.l10n.surname,
              focusNode: _surnameFocus,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => _emailFocus.requestFocus(),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _email,
              label: context.l10n.email,
              focusNode: _emailFocus,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(label: context.l10n.add, onPressed: _submit),
        ),
      ],
    );
  }
}
