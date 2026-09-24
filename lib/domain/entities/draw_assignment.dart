import 'package:equatable/equatable.dart';

import 'participant.dart';

/// One participant's outcome in a drawn raffle.
class DrawAssignment extends Equatable {
  const DrawAssignment({required this.participant, this.match, this.code});

  final Participant participant;

  /// New-year raffle: the name of the person this participant buys a gift for.
  /// Gift raffle: the name of the gift won, or `null` when nothing was won.
  final String? match;

  /// Personal online code once the raffle is published (see `ShareCode`).
  final String? code;

  DrawAssignment withCode(String code) {
    return DrawAssignment(participant: participant, match: match, code: code);
  }

  @override
  List<Object?> get props => <Object?>[participant, match, code];
}
