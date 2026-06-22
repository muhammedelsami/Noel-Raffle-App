import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/raffle_config.dart';
import '../../../domain/entities/raffle_type.dart';
import '../../cubit/raffle_setup/raffle_setup_cubit.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_dropdown.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';
import '../participants/participants_screen.dart';

/// Collects the raffle title, group and sector. Shared by both raffle types.
class RaffleSetupScreen extends StatefulWidget {
  const RaffleSetupScreen({super.key, required this.type});

  final RaffleType type;

  @override
  State<RaffleSetupScreen> createState() => _RaffleSetupScreenState();
}

class _RaffleSetupScreenState extends State<RaffleSetupScreen> {
  final TextEditingController _titleController = TextEditingController();
  final RaffleSetupCubit _cubit = RaffleSetupCubit();

  bool get _isNewYear => widget.type == RaffleType.newYear;

  @override
  void dispose() {
    _titleController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _submit() {
    if (!Validators.isNotBlank(_titleController.text)) {
      showWarningDialog(context, AppStrings.enterTitle);
      return;
    }
    final RaffleSetupState state = _cubit.state;
    final RaffleConfig config = RaffleConfig(
      title: _titleController.text.trim(),
      type: widget.type,
      group: state.group,
      sector: state.sector,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ParticipantsScreen(config: config),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RaffleSetupCubit>.value(
      value: _cubit,
      child: Scaffold(
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
                          label: AppStrings.raffleTitleHint,
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<RaffleSetupCubit, RaffleSetupState>(
                          builder: (context, state) => AppDropdown(
                            value: state.groupLabel,
                            hint: AppStrings.selectRaffleType,
                            items: AppConstants.groupOptions.keys.toList(),
                            onChanged: context.read<RaffleSetupCubit>().selectGroup,
                          ),
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<RaffleSetupCubit, RaffleSetupState>(
                          builder: (context, state) => AppDropdown(
                            value: state.sectorLabel,
                            hint: AppStrings.selectSector,
                            items: AppConstants.sectorOptions.keys.toList(),
                            onChanged:
                                context.read<RaffleSetupCubit>().selectSector,
                          ),
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: _isNewYear
                              ? AppStrings.createNewYearRaffle
                              : AppStrings.createGiftRaffle,
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
      ),
    );
  }
}
