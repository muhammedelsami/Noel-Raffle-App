import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/draw_constraints.dart';
import '../../../domain/entities/match_exclusion.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/raffle.dart';
import '../../../domain/entities/raffle_rules.dart';
import '../../../domain/services/previous_raffle.dart';
import '../../../domain/usecases/get_raffle_history.dart';

part 'participants_state.dart';

/// Manages the in-memory participant list for a raffle and, for a new-year
/// raffle, its matching rules.
class ParticipantsCubit extends Cubit<ParticipantsState> {
  /// Pass [history] for a new-year raffle, so the previous draw of the same
  /// group can be found and its pairs avoided.
  ParticipantsCubit({
    List<Participant> participants = const <Participant>[],
    List<MatchExclusion> exclusions = const <MatchExclusion>[],
    GetRaffleHistory? history,
  }) : super(ParticipantsState(
          participants: participants,
          exclusions: exclusions,
        )) {
    if (history != null) _loadHistory(history);
  }

  /// Past new-year raffles, newest first; empty until loaded.
  List<Raffle> _pastRaffles = const <Raffle>[];

  Future<void> _loadHistory(GetRaffleHistory history) async {
    try {
      _pastRaffles = await history();
    } catch (_) {
      return; // Without history there is simply nothing to avoid.
    }
    if (!isClosed) _emit();
  }

  void add(Participant participant) {
    _emit(participants: <Participant>[...state.participants, participant]);
  }

  /// Adds every participant whose name is not taken yet.
  void addAll(Iterable<Participant> participants) {
    final List<Participant> list = <Participant>[...state.participants];
    for (final Participant participant in participants) {
      if (!_nameIn(list, participant.name)) list.add(participant);
    }
    if (list.length > state.participants.length) _emit(participants: list);
  }

  void update(int index, Participant participant) {
    final String oldName = state.participants[index].name;
    final List<Participant> list = <Participant>[...state.participants];
    list[index] = participant;
    _emit(
      participants: list,
      exclusions: <MatchExclusion>[
        for (final MatchExclusion e in state.exclusions)
          e.renamed(oldName, participant.name),
      ],
    );
  }

  /// Removes the participant at [index] together with their rules.
  void removeAt(int index) {
    final String name = state.participants[index].name;
    final List<Participant> list = <Participant>[...state.participants]
      ..removeAt(index);
    _emit(
      participants: list,
      exclusions: state.exclusions
          .where((MatchExclusion e) => !e.involves(name))
          .toList(),
    );
  }

  /// Adds [rule] unless it names the same person twice or already exists.
  void addExclusion(MatchExclusion rule) {
    if (!canAddExclusion(rule)) return;
    _emit(exclusions: <MatchExclusion>[...state.exclusions, rule]);
  }

  bool canAddExclusion(MatchExclusion rule) =>
      rule.first.toLowerCase() != rule.second.toLowerCase() &&
      !state.exclusions.any((MatchExclusion e) => e.samePairAs(rule));

  void removeExclusion(MatchExclusion rule) {
    _emit(
      exclusions: state.exclusions
          .where((MatchExclusion e) => !e.samePairAs(rule))
          .toList(),
    );
  }

  void setAvoidPrevious(bool avoid) => _emit(avoidPrevious: avoid);

  /// Whether [name] is already used by another participant. Names identify
  /// people in the results, so they must be unique (ignoring case).
  bool nameExists(String name, {int? excludingIndex}) {
    final String normalized = name.trim().toLowerCase();
    for (int i = 0; i < state.participants.length; i++) {
      if (i == excludingIndex) continue;
      if (state.participants[i].name.toLowerCase() == normalized) return true;
    }
    return false;
  }

  static bool _nameIn(List<Participant> list, String name) {
    final String normalized = name.trim().toLowerCase();
    return list.any((Participant p) => p.name.toLowerCase() == normalized);
  }

  void _emit({
    List<Participant>? participants,
    List<MatchExclusion>? exclusions,
    bool? avoidPrevious,
  }) {
    final List<Participant> people = participants ?? state.participants;
    emit(ParticipantsState(
      participants: people,
      exclusions: exclusions ?? state.exclusions,
      previousRaffle: findPreviousRaffle(_pastRaffles, people),
      avoidPrevious: avoidPrevious ?? state.avoidPrevious,
    ));
  }
}
