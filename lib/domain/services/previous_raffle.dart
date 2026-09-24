import '../entities/draw_assignment.dart';
import '../entities/participant.dart';
import '../entities/raffle.dart';

/// The newest new-year raffle in [history] that shares at least two
/// participants with [participants], i.e. "last time" for this group, or
/// `null` when there is none. [history] is newest first.
Raffle? findPreviousRaffle(
  List<Raffle> history,
  List<Participant> participants,
) {
  final Set<String> names = <String>{
    for (final Participant p in participants) p.name.toLowerCase(),
  };
  if (names.length < 2) return null;
  for (final Raffle raffle in history) {
    if (!raffle.type.isNewYear) continue;
    final int shared = raffle.assignments
        .where(
          (DrawAssignment a) =>
              names.contains(a.participant.name.toLowerCase()),
        )
        .length;
    if (shared >= 2) return raffle;
  }
  return null;
}
