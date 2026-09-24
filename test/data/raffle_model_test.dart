import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/data/models/raffle_model.dart';
import 'package:noel_raffle/data/models/statistics_model.dart';
import 'package:noel_raffle/domain/entities/draw_assignment.dart';
import 'package:noel_raffle/domain/entities/gift.dart';
import 'package:noel_raffle/domain/entities/match_exclusion.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/entities/raffle_config.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:noel_raffle/domain/entities/statistics.dart';

void main() {
  final Raffle giftRaffle = Raffle(
    id: 'abc',
    config: const RaffleConfig(
      title: 'Ofis',
      note: 'Bütçe 200 ₺',
      type: RaffleType.gift,
    ),
    createdAt: DateTime.utc(2026, 12, 20, 18, 30),
    gifts: const <Gift>[Gift(name: 'Kupa', count: 2)],
    assignments: const <DrawAssignment>[
      DrawAssignment(
        participant: Participant(name: 'Ayşe', email: 'a@x.com'),
        match: 'Kupa',
        code: 'ABCDEFGH',
      ),
      DrawAssignment(participant: Participant(name: 'Burak'), match: 'Kupa'),
      DrawAssignment(participant: Participant(name: 'Cem')),
    ],
  );

  group('RaffleModel', () {
    test('round-trips through JSON', () {
      final Map<String, dynamic> json =
          RaffleModel.fromEntity(giftRaffle).toJson();
      expect(RaffleModel.fromJson(json), giftRaffle);
    });

    test('round-trips matching rules and reads raffles saved without them', () {
      final Raffle withRules = Raffle(
        id: 'ny',
        config: const RaffleConfig(title: 'Aile', type: RaffleType.newYear),
        createdAt: DateTime.utc(2026, 12, 24),
        assignments: const <DrawAssignment>[
          DrawAssignment(participant: Participant(name: 'A'), match: 'B'),
          DrawAssignment(participant: Participant(name: 'B'), match: 'C'),
          DrawAssignment(participant: Participant(name: 'C'), match: 'A'),
        ],
        exclusions: const <MatchExclusion>[MatchExclusion('A', 'C')],
      );
      final Map<String, dynamic> json =
          RaffleModel.fromEntity(withRules).toJson();
      expect(RaffleModel.fromJson(json), withRules);

      json.remove('exclusions');
      expect(RaffleModel.fromJson(json).exclusions, isEmpty);
    });

    test('omits empty emails and missing codes', () {
      final List<dynamic> assignments = RaffleModel.fromEntity(giftRaffle)
          .toJson()['assignments'] as List<dynamic>;
      expect(
          assignments[1], <String, dynamic>{'name': 'Burak', 'match': 'Kupa'});
    });
  });

  group('StatisticsModel', () {
    test('deltaFor counts a gift raffle', () {
      expect(StatisticsModel.deltaFor(giftRaffle), <String, int>{
        'totalRaffleCount': 1,
        'newYearRaffleCount': 0,
        'giftRaffleCount': 1,
        'participantCount': 3,
        'giftCount': 2,
      });
    });

    test('fromJson defaults missing fields to zero', () {
      final Statistics stats =
          StatisticsModel.fromJson(const <String, dynamic>{'giftCount': 4});
      expect(stats.giftCount, 4);
      expect(stats.totalRaffleCount, 0);
    });
  });
}
