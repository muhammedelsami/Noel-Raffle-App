import 'dart:math';

import '../entities/draw_assignment.dart';
import '../entities/draw_constraints.dart';
import '../entities/gift.dart';
import '../entities/participant.dart';
import '../entities/raffle_rules.dart';
import '../entities/raffle_type.dart';

/// Performs the draw on the device. Pure and synchronous; pass a seeded
/// [Random] in tests for reproducible results.
class RaffleDrawer {
  RaffleDrawer({Random? random}) : _random = random ?? Random.secure();

  final Random _random;

  /// Attempts at a constrained gift circle, and search steps per attempt.
  /// Together they bound the work when the rules leave no valid circle.
  static const int _circleAttempts = 40;
  static const int _stepsPerAttempt = 5000;

  /// Draws [participants] (and [gifts] for a gift raffle) and returns one
  /// assignment per participant, in the original participant order.
  /// A new-year draw also respects [constraints].
  ///
  /// Throws [RaffleRuleException] when the input breaks a [RaffleRules] rule,
  /// or with [RaffleRuleViolation.noValidMatch] when the constraints leave no
  /// valid gift circle.
  List<DrawAssignment> draw({
    required RaffleType type,
    required List<Participant> participants,
    List<Gift> gifts = const <Gift>[],
    DrawConstraints constraints = DrawConstraints.none,
  }) {
    final RaffleRuleViolation? violation = RaffleRules.validate(
      type: type,
      participants: participants,
      gifts: gifts,
    );
    if (violation != null) throw RaffleRuleException(violation);

    final List<String?> matches = switch (type) {
      RaffleType.newYear => constraints.isEmpty
          ? _drawGiftChain(participants)
          : _drawConstrainedChain(participants, constraints),
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

  /// Like [_drawGiftChain], but every giver → receiver step must be allowed
  /// by [constraints]. Searches for such a circle with randomized
  /// backtracking, restarting a bounded number of times.
  List<String?> _drawConstrainedChain(
    List<Participant> participants,
    DrawConstraints constraints,
  ) {
    final int n = participants.length;
    final List<List<int>> allowed = <List<int>>[
      for (int giver = 0; giver < n; giver++)
        <int>[
          for (int receiver = 0; receiver < n; receiver++)
            if (receiver != giver &&
                constraints.allows(
                  participants[giver].name,
                  participants[receiver].name,
                ))
              receiver,
        ],
    ];
    if (allowed.any((List<int> receivers) => receivers.isEmpty)) {
      throw const RaffleRuleException(RaffleRuleViolation.noValidMatch);
    }

    for (int attempt = 0; attempt < _circleAttempts; attempt++) {
      final List<int>? circle = _searchCircle(allowed);
      if (circle == null) continue;
      final List<String?> matches = List<String?>.filled(n, null);
      for (int i = 0; i < n; i++) {
        matches[circle[i]] = participants[circle[(i + 1) % n]].name;
      }
      return matches;
    }
    throw const RaffleRuleException(RaffleRuleViolation.noValidMatch);
  }

  /// One randomized depth-first search for an order of all participants in
  /// which each may give to the next and the last to the first. Returns
  /// `null` when the step budget runs out first.
  List<int>? _searchCircle(List<List<int>> allowed) {
    final int n = allowed.length;
    final int start = _random.nextInt(n);
    final List<int> path = <int>[start];
    final List<bool> used = List<bool>.filled(n, false)..[start] = true;
    int steps = 0;

    bool extend() {
      if (++steps > _stepsPerAttempt) return false;
      if (path.length == n) return allowed[path.last].contains(start);
      final List<int> next = <int>[
        for (final int receiver in allowed[path.last])
          if (!used[receiver]) receiver,
      ]..shuffle(_random);
      for (final int receiver in next) {
        path.add(receiver);
        used[receiver] = true;
        if (extend()) return true;
        path.removeLast();
        used[receiver] = false;
      }
      return false;
    }

    return extend() ? path : null;
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
