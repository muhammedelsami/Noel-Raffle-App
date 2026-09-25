import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/l10n/raffle_texts.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/theme_context.dart';
import '../../../domain/entities/match_exclusion.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/raffle_config.dart';
import '../../../domain/entities/raffle_draft.dart';
import '../../../domain/entities/raffle.dart';
import '../../../domain/entities/raffle_rules.dart';
import '../../../domain/usecases/get_raffle_history.dart';
import '../../cubit/participants/participants_cubit.dart';
import '../../cubit/raffle_draw/raffle_draw_cubit.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_list_tile.dart';
import '../../widgets/bulk_add_dialog.dart';
import '../../widgets/exclusion_form_dialog.dart';
import '../../widgets/editable_list_body.dart';
import '../../widgets/initials_avatar.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/participant_form_dialog.dart';
import '../../widgets/raffle_draw_listener.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_pill.dart';
import '../../widgets/step_header.dart';
import '../../widgets/tile_group.dart';
import '../../widgets/undo_snack_bar.dart';
import '../gifts/gifts_screen.dart';

/// Second step: builds the participant list, then either continues to the
/// gifts step (gift raffle) or draws right away (new-year raffle).
class ParticipantsScreen extends StatelessWidget {
  const ParticipantsScreen({
    super.key,
    required this.config,
    this.draft = RaffleDraft.empty,
  });

  final RaffleConfig config;

  /// People, rules and gifts to start with.
  final RaffleDraft draft;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<ParticipantsCubit>(
          create: (_) => ParticipantsCubit(
            participants: draft.participants,
            exclusions: draft.exclusions,
            history: config.type.isNewYear ? sl<GetRaffleHistory>() : null,
          ),
        ),
        BlocProvider<RaffleDrawCubit>(create: (_) => sl<RaffleDrawCubit>()),
      ],
      child: RaffleDrawListener(
        child: _ParticipantsView(config: config, draft: draft),
      ),
    );
  }
}

class _ParticipantsView extends StatelessWidget {
  const _ParticipantsView({required this.config, required this.draft});

  final RaffleConfig config;
  final RaffleDraft draft;

  Future<void> _addParticipant(BuildContext context) async {
    final ParticipantsCubit cubit = context.read<ParticipantsCubit>();
    final Participant? result = await showParticipantForm(
      context,
      isDuplicate: (String name) => cubit.nameExists(name),
      askWish: config.type.isNewYear,
    );
    if (result != null) cubit.add(result);
  }

  Future<void> _addMany(BuildContext context) async {
    final ParticipantsCubit cubit = context.read<ParticipantsCubit>();
    final List<Participant>? people = await showBulkAddForm(
      context,
      existingNames: <String>[
        for (final Participant p in cubit.state.participants) p.name,
      ],
    );
    if (people != null) cubit.addAll(people);
  }

  void _remove(BuildContext context, int index) {
    final ParticipantsCubit cubit = context.read<ParticipantsCubit>();
    final ParticipantRemoval removal = cubit.removeAt(index);
    showUndoSnackBar(
      context,
      name: removal.participant.name,
      onUndo: () {
        if (!cubit.isClosed) cubit.restore(removal);
      },
    );
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
      isDuplicate: (String name) =>
          cubit.nameExists(name, excludingIndex: index),
      askWish: config.type.isNewYear,
    );
    if (result != null) cubit.update(index, result);
  }

  void _onNext(BuildContext context) {
    final ParticipantsCubit cubit = context.read<ParticipantsCubit>();
    if (!cubit.state.canProceed) {
      showWarningDialog(
        context,
        context.l10n.minParticipants(RaffleRules.minParticipants),
      );
      return;
    }
    final List<Participant> participants = cubit.state.participants;
    if (config.type.hasGifts) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => GiftsScreen(
            config: config,
            participants: participants,
            initialGifts: draft.gifts,
          ),
        ),
      );
    } else {
      context.read<RaffleDrawCubit>().draw(
            config: config,
            participants: participants,
            constraints: cubit.state.constraints,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDrawing =
        context.select((RaffleDrawCubit cubit) => cubit.state.isDrawing);
    return LoadingOverlay(
      isLoading: isDrawing,
      child: PageScaffold(
        title: config.title,
        body: BlocBuilder<ParticipantsCubit, ParticipantsState>(
          builder: (BuildContext context, ParticipantsState state) {
            final List<Participant> participants = state.participants;
            return EditableListBody(
              header: StepHeader(
                type: config.type,
                step: 2,
                title: context.l10n.participantsTitle,
                subtitle:
                    context.l10n.participantsInfo(RaffleRules.minParticipants),
                trailing: CountPill(
                  label: context.l10n.participantCount(participants.length),
                  icon: Icons.group_rounded,
                  complete: state.canProceed,
                ),
              ),
              addButton: Row(
                children: <Widget>[
                  Expanded(
                    child: AppButton.tonal(
                      label: context.l10n.addParticipant,
                      icon: Icons.person_add_alt_1_rounded,
                      onPressed: () => _addParticipant(context),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filledTonal(
                    tooltip: context.l10n.bulkAdd,
                    style: IconButton.styleFrom(
                      minimumSize: const Size.square(52),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.medium,
                      ),
                    ),
                    icon: const Icon(Icons.playlist_add_rounded),
                    onPressed: () => _addMany(context),
                  ),
                ],
              ),
              emptyIcon: Icons.group_add_outlined,
              emptyTitle: context.l10n.participantsEmpty,
              footer: config.type.isNewYear && participants.length >= 2
                  ? _MatchRules(state: state)
                  : null,
              itemCount: participants.length,
              itemBuilder: (BuildContext context, int index) {
                final Participant participant = participants[index];
                final String details = <String?>[
                  participant.email,
                  participant.wish,
                ].nonNulls.where((String s) => s.isNotEmpty).join(' • ');
                return AppListTile(
                  key: ValueKey<String>(participant.name.toLowerCase()),
                  leading: InitialsAvatar(participant.name),
                  title: participant.name,
                  subtitle: details.isEmpty ? null : Text(details),
                  onTap: () => _editParticipant(context, index, participant),
                  onDelete: () => _remove(context, index),
                );
              },
            );
          },
        ),
        bottomBar: AppButton(
          label: config.type.hasGifts
              ? context.l10n.next
              : context.l10n.startRaffle,
          icon: config.type.hasGifts ? null : Icons.celebration_rounded,
          onPressed: () => _onNext(context),
        ),
      ),
    );
  }
}

/// New-year matching rules: avoid last time's pairs and keep people apart.
class _MatchRules extends StatelessWidget {
  const _MatchRules({required this.state});

  final ParticipantsState state;

  Future<void> _addRule(BuildContext context) async {
    final ParticipantsCubit cubit = context.read<ParticipantsCubit>();
    final MatchExclusion? rule = await showExclusionForm(
      context,
      names: <String>[
        for (final Participant p in state.participants) p.name,
      ],
      isNew: cubit.canAddExclusion,
    );
    if (rule != null) cubit.addExclusion(rule);
  }

  @override
  Widget build(BuildContext context) {
    final ParticipantsCubit cubit = context.read<ParticipantsCubit>();
    final ColorScheme colors = context.colors;
    final Raffle? previous = state.previousRaffle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(context.l10n.matchRules),
        TileGroup(
          children: <Widget>[
            if (previous != null)
              SwitchListTile(
                value: state.avoidPrevious,
                onChanged: cubit.setAvoidPrevious,
                secondary: const Icon(Icons.history_rounded),
                title: Text(context.l10n.avoidPrevious),
                subtitle: Text(
                  '${previous.title} • ${raffleDate(context.l10n, previous)}',
                ),
              ),
            for (final MatchExclusion rule in state.exclusions)
              ListTile(
                leading: const Icon(Icons.link_off_rounded),
                title: Text(context.l10n.ruleLabel(rule.first, rule.second)),
                subtitle: Text(context.l10n.ruleDescription),
                trailing: IconButton(
                  tooltip: context.l10n.delete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () => cubit.removeExclusion(rule),
                ),
              ),
            ListTile(
              leading: Icon(Icons.add_rounded, color: colors.primary),
              title: Text(
                context.l10n.addRule,
                style: context.textTheme.titleMedium
                    ?.copyWith(color: colors.primary),
              ),
              onTap: () => _addRule(context),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.sm,
            left: AppSpacing.xs,
            right: AppSpacing.xs,
          ),
          child: Text(
            context.l10n.matchRulesInfo,
            style: context.textTheme.bodySmall
                ?.copyWith(color: colors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
