part of 'participants_cubit.dart';

class ParticipantsState extends Equatable {
  const ParticipantsState({
    this.participants = const <Participant>[],
    this.exclusions = const <MatchExclusion>[],
    this.previousRaffle,
    this.avoidPrevious = true,
  });

  final List<Participant> participants;

  /// New-year rules: people who must not draw each other.
  final List<MatchExclusion> exclusions;

  /// The last new-year raffle of (mostly) the same group, if any.
  final Raffle? previousRaffle;

  /// Whether the draw must avoid [previousRaffle]'s pairs.
  final bool avoidPrevious;

  /// Enough participants have been added to continue.
  bool get canProceed => participants.length >= RaffleRules.minParticipants;

  /// What the new-year draw has to respect.
  DrawConstraints get constraints {
    final Raffle? previous = previousRaffle;
    return avoidPrevious && previous != null
        ? DrawConstraints.avoiding(previous, exclusions: exclusions)
        : DrawConstraints(exclusions: exclusions);
  }

  @override
  List<Object?> get props =>
      <Object?>[participants, exclusions, previousRaffle, avoidPrevious];
}
