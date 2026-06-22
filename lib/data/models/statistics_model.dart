import '../../domain/entities/statistics.dart';

/// Parses the statistics endpoint response into a [Statistics] entity.
class StatisticsModel extends Statistics {
  const StatisticsModel({
    required super.newYearRaffleCount,
    required super.giftRaffleCount,
    required super.participantCount,
    required super.giftCount,
    required super.totalRaffleCount,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    int parse(String key) => (json[key] as num?)?.toInt() ?? 0;
    return StatisticsModel(
      newYearRaffleCount: parse('noelRaffleCount'),
      giftRaffleCount: parse('giftRaffleCount'),
      participantCount: parse('participantCount'),
      giftCount: parse('giftCount'),
      totalRaffleCount: parse('totalRaffleCount'),
    );
  }
}
