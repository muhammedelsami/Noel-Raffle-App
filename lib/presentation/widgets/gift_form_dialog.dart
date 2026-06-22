import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/gift.dart';
import 'app_text_field.dart';
import 'primary_button.dart';

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
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppStrings.allGiftFieldsRequired)),
        );
      return;
    }
    Navigator.of(context).pop(Gift(name: name, count: count));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: AppConstants.dialogInset,
      title: const Text(AppStrings.addGift, textAlign: TextAlign.center),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            AppTextField(
              controller: _name,
              label: AppStrings.giftName,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => _countFocus.requestFocus(),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _count,
              label: AppStrings.giftCount,
              focusNode: _countFocus,
              keyboardType: TextInputType.number,
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
          child: PrimaryButton(label: AppStrings.add, onPressed: _submit),
        ),
      ],
    );
  }
}
