import 'package:equatable/equatable.dart';

/// Aggregate usage numbers shown on the statistics screen.
class Statistics extends Equatable {
  const Statistics({
    required this.newYearRaffleCount,
    required this.giftRaffleCount,
    required this.participantCount,
    required this.giftCount,
    required this.totalRaffleCount,
  });

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
