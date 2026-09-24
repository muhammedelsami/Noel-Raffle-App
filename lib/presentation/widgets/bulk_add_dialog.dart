import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/participant_list_parser.dart';
import '../../domain/entities/participant.dart';
import 'app_text_field.dart';
import 'form_dialog.dart';

/// Lets the organizer paste a whole list of names at once. Resolves to the
/// new participants, without the names in [existingNames], or `null` if
/// dismissed.
Future<List<Participant>?> showBulkAddForm(
  BuildContext context, {
  required Iterable<String> existingNames,
}) {
  return showDialog<List<Participant>>(
    context: context,
    builder: (_) => _BulkAddForm(
      existing: <String>{
        for (final String name in existingNames) name.toLowerCase(),
      },
    ),
  );
}

class _BulkAddForm extends StatefulWidget {
  const _BulkAddForm({required this.existing});

  /// Lower-cased names already on the list.
  final Set<String> existing;

  @override
  State<_BulkAddForm> createState() => _BulkAddFormState();
}

class _BulkAddFormState extends State<_BulkAddForm> {
  final TextEditingController _text = TextEditingController();
  List<Participant> _fresh = const <Participant>[];
  int _skipped = 0;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    final List<Participant> parsed = ParticipantListParser.parse(text);
    final List<Participant> fresh = parsed
        .where(
          (Participant p) => !widget.existing.contains(p.name.toLowerCase()),
        )
        .toList();
    setState(() {
      _fresh = fresh;
      _skipped = parsed.length - fresh.length;
      _error = null;
    });
  }

  void _submit() {
    if (_fresh.isEmpty) {
      setState(() => _error = context.l10n.bulkAddEmpty);
      return;
    }
    Navigator.of(context).pop(_fresh);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? muted = context.textTheme.bodySmall
        ?.copyWith(color: context.colors.onSurfaceVariant);
    return FormDialog(
      title: context.l10n.bulkAdd,
      submitLabel: context.l10n.add,
      onSubmit: _submit,
      error: _error,
      children: <Widget>[
        AppTextField(
          controller: _text,
          label: context.l10n.bulkAddLabel,
          autofocus: true,
          maxLines: 8,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.words,
          onChanged: _onChanged,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(context.l10n.bulkAddHint, style: muted),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          liveRegion: true,
          child: Text(
            context.l10n.bulkAddPreview(_fresh.length),
            style: context.textTheme.titleSmall,
          ),
        ),
        if (_skipped > 0)
          Text(context.l10n.bulkAddSkipped(_skipped), style: muted),
      ],
    );
  }
}
