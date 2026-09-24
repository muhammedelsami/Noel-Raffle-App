import 'dart:math';

import '../entities/draw_assignment.dart';
import '../entities/gift.dart';
import '../entities/participant.dart';
import '../entities/raffle_rules.dart';
import '../entities/raffle_type.dart';

/// Performs the draw on the device. Pure and synchronous; pass a seeded
/// [Random] in tests for reproducible results.
class RaffleDrawer {
  RaffleDrawer({Random? random}) : _random = random ?? Random.secure();

  final Random _random;

  /// Draws [participants] (and [gifts] for a gift raffle) and returns one
  /// assignment per participant, in the original participant order.
  ///
  /// Throws [RaffleRuleException] when the input breaks a [RaffleRules] rule.
  List<DrawAssignment> draw({
    required RaffleType type,
    required List<Participant> participants,
    List<Gift> gifts = const <Gift>[],
  }) {
    final RaffleRuleViolation? violation = RaffleRules.validate(
      type: type,
      participants: participants,
      gifts: gifts,
    );
    if (violation != null) throw RaffleRuleException(violation);

    final List<String?> matches = switch (type) {
      RaffleType.newYear => _drawGiftChain(participants),
      RaffleType.gift => _drawPrizes(participants, gifts),
    };
    return <DrawAssignment>[
      for (int i = 0; i < participants.length; i++)
        DrawAssignment(participant: participants[i], match: matches[i]),
    ];
  }

  /// Shuffles everyone into a single circle where each person gives to the
  /// next. Nobody draws themselves, and with three or more people no two
  /// participants simply swap gifts with each other.
  List<String?> _drawGiftChain(List<Participant> participants) {
    final int n = participants.length;
    final List<int> order = List<int>.generate(n, (int i) => i)
      ..shuffle(_random);
    final List<String?> matches = List<String?>.filled(n, null);
    for (int i = 0; i < n; i++) {
      matches[order[i]] = participants[order[(i + 1) % n]].name;
    }
    return matches;
  }

  /// Hands each gift item to a different random participant; the rest win
  /// nothing.
  List<String?> _drawPrizes(List<Participant> participants, List<Gift> gifts) {
    final List<String> items = <String>[
      for (final Gift gift in gifts)
        for (int i = 0; i < gift.count; i++) gift.name,
    ];
    final List<int> order =
        List<int>.generate(participants.length, (int i) => i)..shuffle(_random);
    final List<String?> matches =
        List<String?>.filled(participants.length, null);
    for (int i = 0; i < items.length; i++) {
      matches[order[i]] = items[i];
    }
    return matches;
  }
}
