import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/participant.dart';
import 'app_text_field.dart';
import 'form_dialog.dart';

/// Shows the add/edit participant form and resolves to the saved
/// [Participant], or `null` if dismissed.
///
/// [isDuplicate] is asked before saving so the same name cannot be added
/// twice (the participant being edited is excluded by the caller).
/// [askWish] adds the gift ideas field, used by new-year raffles.
Future<Participant?> showParticipantForm(
  BuildContext context, {
  Participant? initial,
  required bool Function(String name) isDuplicate,
  bool askWish = false,
}) {
  return showDialog<Participant>(
    context: context,
    builder: (_) => _ParticipantForm(
      initial: initial,
      isDuplicate: isDuplicate,
      askWish: askWish,
    ),
  );
}

class _ParticipantForm extends StatefulWidget {
  const _ParticipantForm({
    this.initial,
    required this.isDuplicate,
    required this.askWish,
  });

  final Participant? initial;
  final bool Function(String name) isDuplicate;
  final bool askWish;

  @override
  State<_ParticipantForm> createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<_ParticipantForm> {
  late final TextEditingController _name =
      TextEditingController(text: widget.initial?.name);
  late final TextEditingController _email =
      TextEditingController(text: widget.initial?.email);
  late final TextEditingController _wish =
      TextEditingController(text: widget.initial?.wish);

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _wishFocus = FocusNode();

  /// Validation message shown inside the dialog. A SnackBar would outlive the
  /// dialog and cover the buttons of the screen below.
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _wish.dispose();
    _emailFocus.dispose();
    _wishFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final String name = _name.text.trim();
    final String email = _email.text.trim();
    final String wish = _wish.text.trim();

    final String? error = _validate(name, email);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(
      Participant(
        name: name,
        email: email.isEmpty ? null : email,
        wish: wish.isEmpty ? null : wish,
      ),
    );
  }

  String? _validate(String name, String email) {
    if (!Validators.isNotBlank(name)) return context.l10n.nameRequired;
    if (!Validators.isValidOptionalEmail(email)) {
      return context.l10n.invalidEmail;
    }
    if (widget.isDuplicate(name)) return context.l10n.nameAlreadyAdded;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isNew = widget.initial == null;
    return FormDialog(
      title: isNew ? context.l10n.newParticipant : context.l10n.editParticipant,
      submitLabel: isNew ? context.l10n.add : context.l10n.save,
      onSubmit: _submit,
      error: _error,
      children: <Widget>[
        AppTextField(
          controller: _name,
          label: context.l10n.name,
          icon: Icons.person_outline_rounded,
          autofocus: true,
          maxLength: AppConstants.maxNameLength,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _emailFocus.requestFocus(),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _email,
          label: context.l10n.emailOptional,
          icon: Icons.alternate_email_rounded,
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction:
              widget.askWish ? TextInputAction.next : TextInputAction.done,
          onSubmitted: (_) =>
              widget.askWish ? _wishFocus.requestFocus() : _submit(),
        ),
        if (widget.askWish) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _wish,
            label: context.l10n.wishOptional,
            icon: Icons.lightbulb_outline_rounded,
            focusNode: _wishFocus,
            maxLength: AppConstants.maxWishLength,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ],
    );
  }
}
