import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/gift.dart';
import 'app_text_field.dart';
import 'form_dialog.dart';

/// Shows the add/edit gift form and resolves to the saved [Gift], or `null`
/// if dismissed.
Future<Gift?> showGiftForm(BuildContext context, {Gift? initial}) {
  return showDialog<Gift>(
    context: context,
    builder: (_) => _GiftForm(initial: initial),
  );
}

class _GiftForm extends StatefulWidget {
  const _GiftForm({this.initial});

  final Gift? initial;

  @override
  State<_GiftForm> createState() => _GiftFormState();
}

class _GiftFormState extends State<_GiftForm> {
  late final TextEditingController _name =
      TextEditingController(text: widget.initial?.name);
  late final TextEditingController _count = TextEditingController(
    text: widget.initial == null ? null : '${widget.initial!.count}',
  );

  final FocusNode _countFocus = FocusNode();

  /// Validation message shown inside the dialog (see the participant form).
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _count.dispose();
    _countFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final String name = _name.text.trim();
    final int? count = int.tryParse(_count.text.trim());

    if (!Validators.isNotBlank(name) || count == null || count <= 0) {
      setState(() => _error = context.l10n.allGiftFieldsRequired);
      return;
    }
    Navigator.of(context).pop(Gift(name: name, count: count));
  }

  @override
  Widget build(BuildContext context) {
    final bool isNew = widget.initial == null;
    return FormDialog(
      title: isNew ? context.l10n.newGift : context.l10n.editGift,
      submitLabel: isNew ? context.l10n.add : context.l10n.save,
      onSubmit: _submit,
      error: _error,
      children: <Widget>[
        AppTextField(
          controller: _name,
          label: context.l10n.giftName,
          icon: Icons.card_giftcard_rounded,
          autofocus: true,
          maxLength: AppConstants.maxNameLength,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _countFocus.requestFocus(),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _count,
          label: context.l10n.giftCount,
          icon: Icons.tag_rounded,
          focusNode: _countFocus,
          keyboardType: TextInputType.number,
          maxLength: AppConstants.maxGiftCountDigits,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
      ],
    );
  }
}
