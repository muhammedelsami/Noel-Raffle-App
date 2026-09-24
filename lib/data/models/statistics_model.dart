import '../../domain/entities/raffle.dart';
import '../../domain/entities/statistics.dart';

/// Firestore form of the global counters document (`stats/global`).
class StatisticsModel extends Statistics {
  const StatisticsModel({
    required super.newYearRaffleCount,
    required super.giftRaffleCount,
    required super.participantCount,
    required super.giftCount,
    required super.totalRaffleCount,
  });

  /// Parses into the plain entity, so parsed values compare equal to entities
  /// built elsewhere (Equatable also compares runtime types).
  static Statistics fromJson(Map<String, dynamic> json) {
    int parse(String key) => (json[key] as num?)?.toInt() ?? 0;
    return Statistics(
      newYearRaffleCount: parse('newYearRaffleCount'),
      giftRaffleCount: parse('giftRaffleCount'),
      participantCount: parse('participantCount'),
      giftCount: parse('giftCount'),
      totalRaffleCount: parse('totalRaffleCount'),
    );
  }

  /// How much each counter grows when [raffle] is recorded. Every key is
  /// always present so the security rules can validate the whole document.
  static Map<String, int> deltaFor(Raffle raffle) {
    final bool newYear = raffle.type.isNewYear;
    return <String, int>{
      'totalRaffleCount': 1,
      'newYearRaffleCount': newYear ? 1 : 0,
      'giftRaffleCount': newYear ? 0 : 1,
      'participantCount': raffle.assignments.length,
      'giftCount': raffle.giftUnitCount,
    };
  }
}
