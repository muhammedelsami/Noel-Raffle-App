import 'package:flutter/material.dart';

/// Themed dropdown built on [DropdownButtonFormField] so it inherits the
/// shared input decoration. Generic over the option value type so callers can
/// keep backend codes as values while showing localized labels.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String hint;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      hint: Text(hint),
      items: items,
      onChanged: onChanged,
    );
  }
}
