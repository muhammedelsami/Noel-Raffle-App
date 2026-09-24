import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/l10n/raffle_texts.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/raffle_type_style.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/raffle_config.dart';
import '../../../domain/entities/raffle_type.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/illustration.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/step_header.dart';
import '../participants/participants_screen.dart';

/// First step of both flows: the raffle title and an optional note for the
/// participants.
class RaffleSetupScreen extends StatefulWidget {
  const RaffleSetupScreen({super.key, required this.type});

  final RaffleType type;

  @override
  State<RaffleSetupScreen> createState() => _RaffleSetupScreenState();
}

class _RaffleSetupScreenState extends State<RaffleSetupScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();

  /// Shown under the title field after a submit without a title.
  String? _titleError;

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _titleFocus.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  void _onTitleChanged(String _) {
    if (_titleError != null) setState(() => _titleError = null);
  }

  void _submit() {
    if (!Validators.isNotBlank(_titleController.text)) {
      setState(() => _titleError = context.l10n.enterTitle);
      _titleFocus.requestFocus();
      return;
    }
    final RaffleConfig config = RaffleConfig(
      title: _titleController.text.trim(),
      note: _noteController.text.trim(),
      type: widget.type,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ParticipantsScreen(config: config),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: raffleTypeLabel(context.l10n, widget.type),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xl,
        ),
        children: <Widget>[
          StepHeader(
            type: widget.type,
            step: 1,
            title: context.l10n.raffleDetails,
            subtitle: context.l10n.raffleDetailsInfo,
            trailing: Illustration(widget.type.illustration, size: 64),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            controller: _titleController,
            focusNode: _titleFocus,
            label: context.l10n.raffleTitleHint,
            icon: Icons.edit_outlined,
            errorText: _titleError,
            maxLength: AppConstants.maxTitleLength,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            onChanged: _onTitleChanged,
            onSubmitted: (_) => _noteFocus.requestFocus(),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _noteController,
            focusNode: _noteFocus,
            label: context.l10n.raffleNoteHint,
            icon: Icons.notes_rounded,
            maxLength: AppConstants.maxNoteLength,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
      bottomBar: AppButton(label: context.l10n.next, onPressed: _submit),
    );
  }
}
