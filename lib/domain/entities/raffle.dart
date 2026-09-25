import 'package:equatable/equatable.dart';

import 'draw_assignment.dart';
import 'gift.dart';
import 'match_exclusion.dart';
import 'raffle_config.dart';
import 'raffle_type.dart';

/// A raffle that has been drawn on the device. [assignments] keep the order in
/// which participants were entered.
class Raffle extends Equatable {
  const Raffle({
    required this.id,
    required this.config,
    required this.createdAt,
    required this.assignments,
    this.gifts = const <Gift>[],
    this.exclusions = const <MatchExclusion>[],
  });

  final String id;
  final RaffleConfig config;
  final DateTime createdAt;
  final List<DrawAssignment> assignments;
  final List<Gift> gifts;

  /// New-year rules the draw respected, kept so the raffle can be run again.
  final List<MatchExclusion> exclusions;

  String get title => config.title;
  String get note => config.note;
  RaffleType get type => config.type;
  DateTime? get eventDate => config.eventDate;

  /// Whether every participant has a personal online code.
  bool get isPublished =>
      assignments.isNotEmpty &&
      assignments.every((DrawAssignment a) => a.code != null);

  /// Gift ideas of the participant called [name], if they left any.
  String? wishOf(String? name) {
    if (name == null) return null;
    for (final DrawAssignment a in assignments) {
      if (a.participant.name == name && a.participant.hasWish) {
        return a.participant.wish;
      }
    }
    return null;
  }

  /// Total number of gift items handed out (a gift with count 3 counts as 3).
  int get giftUnitCount => gifts.fold(0, (int sum, Gift g) => sum + g.count);

  Raffle copyWith({List<DrawAssignment>? assignments}) {
    return Raffle(
      id: id,
      config: config,
      createdAt: createdAt,
      assignments: assignments ?? this.assignments,
      gifts: gifts,
      exclusions: exclusions,
    );
  }

  @override
  List<Object?> get props =>
      <Object?>[id, config, createdAt, assignments, gifts, exclusions];
}
