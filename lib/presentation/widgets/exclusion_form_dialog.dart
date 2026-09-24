import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/app_dimens.dart';
import '../../domain/entities/match_exclusion.dart';
import 'form_dialog.dart';

/// Asks which two of [names] must not draw each other. Resolves to the new
/// rule, or `null` if dismissed. [isNew] rejects a rule that already exists.
Future<MatchExclusion?> showExclusionForm(
  BuildContext context, {
  required List<String> names,
  required bool Function(MatchExclusion rule) isNew,
}) {
  return showDialog<MatchExclusion>(
    context: context,
    builder: (_) => _ExclusionForm(names: names, isNew: isNew),
  );
}

class _ExclusionForm extends StatefulWidget {
  const _ExclusionForm({required this.names, required this.isNew});

  final List<String> names;
  final bool Function(MatchExclusion rule) isNew;

  @override
  State<_ExclusionForm> createState() => _ExclusionFormState();
}

class _ExclusionFormState extends State<_ExclusionForm> {
  late String _first = widget.names.first;
  late String _second = widget.names[1];
  String? _error;

  void _submit() {
    final MatchExclusion rule = MatchExclusion(_first, _second);
    if (_first == _second) {
      setState(() => _error = context.l10n.ruleSamePerson);
    } else if (!widget.isNew(rule)) {
      setState(() => _error = context.l10n.ruleExists);
    } else {
      Navigator.of(context).pop(rule);
    }
  }

  Widget _picker({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.person_outline_rounded),
      ),
      items: <DropdownMenuItem<String>>[
        for (final String name in widget.names)
          DropdownMenuItem<String>(
            value: name,
            child: Text(name, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (String? name) {
        if (name != null) setState(() => onChanged(name));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      title: context.l10n.keepApart,
      submitLabel: context.l10n.add,
      onSubmit: _submit,
      error: _error,
      children: <Widget>[
        _picker(
          label: context.l10n.firstPerson,
          value: _first,
          onChanged: (String name) => _first = name,
        ),
        const SizedBox(height: AppSpacing.md),
        _picker(
          label: context.l10n.secondPerson,
          value: _second,
          onChanged: (String name) => _second = name,
        ),
      ],
    );
  }
}
