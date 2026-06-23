import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../domain/entities/gift.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/raffle_config.dart';
import '../../cubit/gifts/gifts_cubit.dart';
import '../../cubit/raffle_submit/raffle_submit_cubit.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_list_tile_card.dart';
import '../../widgets/gift_form_dialog.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/primary_button.dart';
import '../success/success_screen.dart';

/// Lets the user build the gift list, then submits the gift raffle.
class GiftsScreen extends StatelessWidget {
  const GiftsScreen({
    super.key,
    required this.config,
    required this.participants,
  });

  final RaffleConfig config;
  final List<Participant> participants;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<GiftsCubit>(create: (_) => GiftsCubit()),
        BlocProvider<RaffleSubmitCubit>(create: (_) => sl<RaffleSubmitCubit>()),
      ],
      child: _GiftsView(config: config, participants: participants),
    );
  }
}

class _GiftsView extends StatelessWidget {
  const _GiftsView({required this.config, required this.participants});

  final RaffleConfig config;
  final List<Participant> participants;

  Future<void> _addGift(BuildContext context) async {
    final GiftsCubit cubit = context.read<GiftsCubit>();
    final Gift? result = await showGiftForm(context);
    if (result != null) cubit.add(result);
  }

  Future<void> _editGift(BuildContext context, int index, Gift gift) async {
    final GiftsCubit cubit = context.read<GiftsCubit>();
    final Gift? result = await showGiftForm(context, initial: gift);
    if (result != null) cubit.update(index, result);
  }

  void _start(BuildContext context) {
    final GiftsCubit cubit = context.read<GiftsCubit>();
    if (!cubit.state.canProceed) {
      showWarningDialog(context, context.l10n.minGifts);
      return;
    }
    context.read<RaffleSubmitCubit>().submit(
          config: config,
          participants: participants,
          gifts: cubit.state.gifts,
        );
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
                      AppAssets.giftHand,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.pagePadding,
                      ),
                      child: PrimaryButton(
                        label: context.l10n.addGift,
                        icon: Icons.add_box_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () => _addGift(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(child: _GiftList(onEdit: _editGift)),
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.pagePadding),
                      child: PrimaryButton(
                        label: context.l10n.startRaffle,
                        icon: Icons.celebration_rounded,
                        onPressed: () => _start(context),
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

class _GiftList extends StatelessWidget {
  const _GiftList({required this.onEdit});

  final void Function(BuildContext, int, Gift) onEdit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GiftsCubit, GiftsState>(
      builder: (BuildContext context, GiftsState state) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.pagePadding,
          ),
          itemCount: state.gifts.length,
          itemBuilder: (BuildContext context, int index) {
            final Gift gift = state.gifts[index];
            return AppListTileCard(
              title: gift.name,
              subtitle: '${gift.count}',
              onTap: () => onEdit(context, index, gift),
              onDelete: () => context.read<GiftsCubit>().removeAt(index),
            );
          },
        );
      },
    );
  }
}
