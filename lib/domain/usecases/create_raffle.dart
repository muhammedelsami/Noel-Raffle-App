import 'dart:async';

import '../entities/draw_assignment.dart';
import '../entities/draw_constraints.dart';
import '../entities/gift.dart';
import '../entities/match_exclusion.dart';
import '../entities/participant.dart';
import '../entities/raffle.dart';
import '../entities/raffle_config.dart';
import '../repositories/online_raffle_repository.dart';
import '../repositories/raffle_history_repository.dart';
import '../services/raffle_drawer.dart';

/// Draws a raffle on the device and saves it to the local history.
class CreateRaffle {
  CreateRaffle(
    this._drawer,
    this._history,
    this._online, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final RaffleDrawer _drawer;
  final RaffleHistoryRepository _history;
  final OnlineRaffleRepository _online;
  final DateTime Function() _clock;

  /// Throws `RaffleRuleException` when the raffle cannot be drawn yet.
  Future<Raffle> call({
    required RaffleConfig config,
    required List<Participant> participants,
    List<Gift> gifts = const <Gift>[],
    DrawConstraints constraints = DrawConstraints.none,
  }) async {
    final List<DrawAssignment> assignments = _drawer.draw(
      type: config.type,
      participants: participants,
      gifts: gifts,
      constraints: constraints,
    );
    final DateTime now = _clock();
    final Raffle raffle = Raffle(
      id: now.microsecondsSinceEpoch.toRadixString(36),
      config: config,
      createdAt: now,
      assignments: assignments,
      gifts: config.type.hasGifts ? gifts : const <Gift>[],
      exclusions: config.type.hasGifts
          ? const <MatchExclusion>[]
          : constraints.exclusions,
    );
    await _history.save(raffle);

    // Global counters are best-effort: they must never delay or fail a draw.
    if (_online.isAvailable) {
      unawaited(_online.recordStatistics(raffle).catchError((Object _) {}));
    }
    return raffle;
  }
}
