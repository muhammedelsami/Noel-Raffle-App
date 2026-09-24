import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/raffle_type_style.dart';
import '../../../core/theme/theme_context.dart';
import '../../../domain/entities/gift.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/raffle_config.dart';
import '../../../domain/entities/raffle_rules.dart';
import '../../cubit/gifts/gifts_cubit.dart';
import '../../cubit/raffle_draw/raffle_draw_cubit.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_list_tile.dart';
import '../../widgets/editable_list_body.dart';
import '../../widgets/gift_form_dialog.dart';
import '../../widgets/icon_badge.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/raffle_draw_listener.dart';
import '../../widgets/status_pill.dart';
import '../../widgets/step_header.dart';

/// Last step of the gift raffle: builds the gift list, then draws.
class GiftsScreen extends StatelessWidget {
  const GiftsScreen({
    super.key,
    required this.config,
    required this.participants,
    this.initialGifts = const <Gift>[],
  });

  final RaffleConfig config;
  final List<Participant> participants;

  /// Gifts to start with, e.g. from a past raffle drawn again.
  final List<Gift> initialGifts;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<GiftsCubit>(
          create: (_) => GiftsCubit(gifts: initialGifts),
        ),
        BlocProvider<RaffleDrawCubit>(create: (_) => sl<RaffleDrawCubit>()),
      ],
      child: RaffleDrawListener(
        child: _GiftsView(config: config, participants: participants),
      ),
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
      showWarningDialog(context, context.l10n.minGifts(RaffleRules.minGifts));
      return;
    }
    context.read<RaffleDrawCubit>().draw(
          config: config,
          participants: participants,
          gifts: cubit.state.gifts,
        );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDrawing =
        context.select((RaffleDrawCubit cubit) => cubit.state.isDrawing);
    final AccentColors accent = config.type.accentColors(context.colors);
    return LoadingOverlay(
      isLoading: isDrawing,
      child: PageScaffold(
        title: config.title,
        body: BlocBuilder<GiftsCubit, GiftsState>(
          builder: (BuildContext context, GiftsState state) {
            final List<Gift> gifts = state.gifts;
            final bool tooManyGifts = RaffleRules.validate(
                  type: config.type,
                  participants: participants,
                  gifts: gifts,
                ) ==
                RaffleRuleViolation.tooManyGifts;
            return EditableListBody(
              header: StepHeader(
                type: config.type,
                step: 3,
                title: context.l10n.giftsTitle,
                subtitle: context.l10n.giftsInfo,
                trailing: StatusPill(
                  label: context.l10n.giftUnits(state.units),
                  icon: Icons.card_giftcard_rounded,
                ),
              ),
              notice: tooManyGifts
                  ? InfoBanner(
                      tone: BannerTone.error,
                      message: context.l10n.tooManyGifts,
                    )
                  : null,
              addButton: AppButton.tonal(
                label: context.l10n.addGift,
                icon: Icons.add_rounded,
                onPressed: () => _addGift(context),
              ),
              emptyIcon: Icons.redeem_outlined,
              emptyTitle: context.l10n.giftsEmpty,
              itemCount: gifts.length,
              itemBuilder: (BuildContext context, int index) {
                final Gift gift = gifts[index];
                return AppListTile(
                  key: ObjectKey(gift),
                  leading: IconBadge(
                    icon: Icons.card_giftcard_rounded,
                    background: accent.container,
                    foreground: accent.onContainer,
                  ),
                  title: gift.name,
                  subtitle: Text(context.l10n.giftQuantity(gift.count)),
                  onTap: () => _editGift(context, index, gift),
                  onDelete: () => context.read<GiftsCubit>().removeAt(index),
                );
              },
            );
          },
        ),
        bottomBar: AppButton(
          label: context.l10n.startRaffle,
          icon: Icons.celebration_rounded,
          onPressed: () => _start(context),
        ),
      ),
    );
  }
}
