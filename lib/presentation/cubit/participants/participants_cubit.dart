import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/participant.dart';
import '../../../domain/entities/raffle_rules.dart';

part 'participants_state.dart';

/// Manages the in-memory participant list for a raffle.
class ParticipantsCubit extends Cubit<ParticipantsState> {
  ParticipantsCubit() : super(const ParticipantsState());

  void add(Participant participant) {
    emit(ParticipantsState(
      participants: <Participant>[...state.participants, participant],
    ));
  }

  void update(int index, Participant participant) {
    final List<Participant> list = <Participant>[...state.participants];
    list[index] = participant;
    emit(ParticipantsState(participants: list));
  }

  void removeAt(int index) {
    final List<Participant> list = <Participant>[...state.participants]
      ..removeAt(index);
    emit(ParticipantsState(participants: list));
  }

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
}
