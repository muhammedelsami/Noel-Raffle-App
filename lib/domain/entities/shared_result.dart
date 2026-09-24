import 'package:equatable/equatable.dart';

import 'raffle_type.dart';

/// A single participant's result as fetched with their personal online code.
/// It carries only what that participant is allowed to see.
class SharedResult extends Equatable {
  const SharedResult({
    required this.title,
    required this.type,
    required this.participantName,
    this.match,
    this.matchWish,
    this.note = '',
  });

  final String title;
  final RaffleType type;
  final String participantName;

  /// See `DrawAssignment.match`.
  final String? match;

  /// New-year raffle: the gift ideas of [match], if they left any.
  final String? matchWish;
  final String note;

  @override
  List<Object?> get props =>
      <Object?>[title, type, participantName, match, matchWish, note];
}
