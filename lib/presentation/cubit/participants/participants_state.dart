part of 'participants_cubit.dart';

class ParticipantsState extends Equatable {
  const ParticipantsState({this.participants = const <Participant>[]});

  final List<Participant> participants;

  /// Enough participants have been added to continue.
  bool get canProceed => participants.length >= RaffleRules.minParticipants;

  @override
  List<Object?> get props => <Object?>[participants];
}
