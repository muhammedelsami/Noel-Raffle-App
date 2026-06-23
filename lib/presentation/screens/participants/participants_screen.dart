import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/raffle_config.dart';
import '../../cubit/participants/participants_cubit.dart';
import '../../cubit/raffle_submit/raffle_submit_cubit.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_list_tile_card.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/participant_form_dialog.dart';
import '../../widgets/primary_button.dart';
import '../gifts/gifts_screen.dart';
import '../success/success_screen.dart';

/// Lets the user build the participant list, then either continues to the
/// gifts step (gift raffle) or submits directly (new-year raffle).
class ParticipantsScreen extends StatelessWidget {
  const ParticipantsScreen({super.key, required this.config});

  final RaffleConfig config;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<ParticipantsCubit>(create: (_) => ParticipantsCubit()),
        BlocProvider<RaffleSubmitCubit>(create: (_) => sl<RaffleSubmitCubit>()),
      ],
      child: _ParticipantsView(config: config),
    );
  }
}

class _ParticipantsView extends StatelessWidget {
  const _ParticipantsView({required this.config});

  final RaffleConfig config;

  bool get _isNewYear => config.type.isNewYear;

  Future<void> _addParticipant(BuildContext context) async {
    final ParticipantsCubit cubit = context.read<ParticipantsCubit>();
    final Participant? result = await showParticipantForm(
      context,
      isDuplicate: (String email) => cubit.emailExists(email),
    );
    if (result != null) cubit.add(result);
  }

  Future<void> _editParticipant(
    BuildContext context,
    int index,
    Participant participant,
  ) async {
    final ParticipantsCubit cubit = context.read<ParticipantsCubit>();
    final Participant? result = await showParticipantForm(
      context,
      initial: participant,
      isDuplicate: (String email) =>
          cubit.emailExists(email, excludingIndex: index),
    );
    if (result != null) cubit.update(index, result);
  }

  void _onNext(BuildContext context) {
    final ParticipantsCubit cubit = context.read<ParticipantsCubit>();
    if (!cubit.state.canProceed) {
      showWarningDialog(context, context.l10n.minParticipants);
      return;
    }
    final List<Participant> participants = cubit.state.participants;
    if (_isNewYear) {
      context
          .read<RaffleSubmitCubit>()
          .submit(config: config, participants: participants);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              GiftsScreen(config: config, participants: participants),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RaffleSubmitCubit, RaffleSubmitState>(
      listener: (BuildContext context, RaffleSubmitState state) {
        if (state.status == RaffleSubmitStatus.success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => const SuccessScreen()),
          );
        } else if (state.status == RaffleSubmitStatus.failure) {
          showWarningDialog(context, state.error ?? context.l10n.genericError);
        }
      },
      builder: (BuildContext context, RaffleSubmitState submitState) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(),
          body: AppBackground(
            child: SafeArea(
              child: LoadingOverlay(
                isLoading: submitState.isLoading,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      _isNewYear ? AppAssets.newYearLogo : AppAssets.giftHand,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.pagePadding,
                      ),
                      child: PrimaryButton(
                        label: context.l10n.addParticipant,
                        icon: Icons.person_add_alt_1_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () => _addParticipant(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(child: _ParticipantList(onEdit: _editParticipant)),
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.pagePadding),
                      child: PrimaryButton(
                        label: context.l10n.next,
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => _onNext(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ParticipantList extends StatelessWidget {
  const _ParticipantList({required this.onEdit});

  final void Function(BuildContext, int, Participant) onEdit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParticipantsCubit, ParticipantsState>(
      builder: (BuildContext context, ParticipantsState state) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.pagePadding,
          ),
          itemCount: state.participants.length,
          itemBuilder: (BuildContext context, int index) {
            final Participant participant = state.participants[index];
            return AppListTileCard(
              title: participant.fullName,
              subtitle: participant.email,
              onTap: () => onEdit(context, index, participant),
              onDelete: () =>
                  context.read<ParticipantsCubit>().removeAt(index),
            );
          },
        );
      },
    );
  }
}
