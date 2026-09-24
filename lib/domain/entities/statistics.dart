import 'package:equatable/equatable.dart';

import 'raffle.dart';

/// Aggregate usage numbers shown on the statistics screen.
class Statistics extends Equatable {
  const Statistics({
    required this.newYearRaffleCount,
    required this.giftRaffleCount,
    required this.participantCount,
    required this.giftCount,
    required this.totalRaffleCount,
  });

  /// Totals over the given raffles (used for this device's history).
  factory Statistics.fromRaffles(List<Raffle> raffles) {
    int newYear = 0;
    int participants = 0;
    int gifts = 0;
    for (final Raffle raffle in raffles) {
      if (raffle.type.isNewYear) newYear++;
      participants += raffle.assignments.length;
      gifts += raffle.giftUnitCount;
    }
    return Statistics(
      newYearRaffleCount: newYear,
      giftRaffleCount: raffles.length - newYear,
      participantCount: participants,
      giftCount: gifts,
      totalRaffleCount: raffles.length,
    );
  }

  final int newYearRaffleCount;
  final int giftRaffleCount;
  final int participantCount;
  final int giftCount;
  final int totalRaffleCount;

  @override
  List<Object?> get props => <Object?>[
        newYearRaffleCount,
        giftRaffleCount,
        participantCount,
        giftCount,
        totalRaffleCount,
      ];
}
