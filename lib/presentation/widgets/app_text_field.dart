import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Themed text field used across forms.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.errorText,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.maxLength,
    this.maxLines = 1,
    this.inputFormatters = const <TextInputFormatter>[],
  });

  final TextEditingController controller;
  final String label;

  /// Leading icon inside the field.
  final IconData? icon;

  /// Shown below the field and outlines it in the error color.
  final String? errorText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  /// Silently caps the input length (no visible counter).
  final int? maxLength;
  final int maxLines;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      minLines: 1,
      maxLines: maxLines,
      inputFormatters: <TextInputFormatter>[
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ...inputFormatters,
      ],
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        prefixIcon: icon == null ? null : Icon(icon),
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }
}
