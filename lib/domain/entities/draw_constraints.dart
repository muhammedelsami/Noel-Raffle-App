import 'package:equatable/equatable.dart';

import 'draw_assignment.dart';
import 'match_exclusion.dart';
import 'raffle.dart';

/// Who must not buy a gift for whom in a new-year raffle.
class DrawConstraints extends Equatable {
  const DrawConstraints({
    this.exclusions = const <MatchExclusion>[],
    this.previousMatches = const <String, String>{},
  });

  /// Avoids repeating [previous]'s pairs, on top of [exclusions].
  factory DrawConstraints.avoiding(
    Raffle previous, {
    List<MatchExclusion> exclusions = const <MatchExclusion>[],
  }) {
    return DrawConstraints(
      exclusions: exclusions,
      previousMatches: <String, String>{
        for (final DrawAssignment a in previous.assignments)
          if (a.match != null)
            a.participant.name.toLowerCase(): a.match!.toLowerCase(),
      },
    );
  }

  static const DrawConstraints none = DrawConstraints();

  final List<MatchExclusion> exclusions;

  /// A previous raffle's giver → receiver pairs, lower-cased, that must not
  /// happen again.
  final Map<String, String> previousMatches;

  bool get isEmpty => exclusions.isEmpty && previousMatches.isEmpty;

  /// Whether [giver] may buy a gift for [receiver].
  bool allows(String giver, String receiver) {
    if (previousMatches[giver.toLowerCase()] == receiver.toLowerCase()) {
      return false;
    }
    return !exclusions.any((MatchExclusion e) => e.blocks(giver, receiver));
  }

  @override
  List<Object?> get props => <Object?>[exclusions, previousMatches];
}
