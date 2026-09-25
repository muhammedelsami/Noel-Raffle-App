import 'draw_assignment.dart';
import 'gift.dart';
import 'match_exclusion.dart';
import 'participant.dart';
import 'raffle.dart';

/// What a new raffle starts with: empty, or a past raffle's people, gifts
/// and matching rules when the same group draws again.
class RaffleDraft {
  const RaffleDraft({
    this.participants = const <Participant>[],
    this.gifts = const <Gift>[],
    this.exclusions = const <MatchExclusion>[],
  });

  factory RaffleDraft.from(Raffle raffle) {
    return RaffleDraft(
      participants: <Participant>[
        for (final DrawAssignment a in raffle.assignments) a.participant,
      ],
      gifts: raffle.gifts,
      exclusions: raffle.exclusions,
    );
  }

  static const RaffleDraft empty = RaffleDraft();

  final List<Participant> participants;
  final List<Gift> gifts;
  final List<MatchExclusion> exclusions;
}
