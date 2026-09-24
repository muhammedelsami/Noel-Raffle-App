import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/raffle_config.dart';
import '../../../domain/entities/raffle_type.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';
import '../participants/participants_screen.dart';

/// Collects the raffle title and an optional note for participants. Shared by
/// both raffle types.
class RaffleSetupScreen extends StatefulWidget {
  const RaffleSetupScreen({super.key, required this.type});

  final RaffleType type;

  @override
  State<RaffleSetupScreen> createState() => _RaffleSetupScreenState();
}

class _RaffleSetupScreenState extends State<RaffleSetupScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool get _isNewYear => widget.type.isNewYear;

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!Validators.isNotBlank(_titleController.text)) {
      showWarningDialog(context, context.l10n.enterTitle);
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.pagePadding),
            child: Column(
              children: <Widget>[
                Image.asset(
                  _isNewYear ? AppAssets.newYearLogo : AppAssets.giftHand,
                  height: 220,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                GlassCard(
                  child: Column(
                    children: <Widget>[
                      AppTextField(
                        controller: _titleController,
                        label: context.l10n.raffleTitleHint,
                        maxLength: AppConstants.maxTitleLength,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _noteController,
                        label: context.l10n.raffleNoteHint,
                        maxLength: AppConstants.maxNoteLength,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: _isNewYear
                            ? context.l10n.createNewYearRaffle
                            : context.l10n.createGiftRaffle,
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
