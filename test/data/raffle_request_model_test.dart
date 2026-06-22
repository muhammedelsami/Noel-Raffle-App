import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/core/constants/app_constants.dart';
import 'package:noel_raffle/data/models/raffle_request_model.dart';
import 'package:noel_raffle/data/models/statistics_model.dart';
import 'package:noel_raffle/domain/entities/gift.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/domain/entities/raffle_config.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';

void main() {
  const RaffleConfig config = RaffleConfig(
    title: 'Ofis',
    type: RaffleType.gift,
    group: 10,
    sector: 20,
  );
  const List<Participant> participants = <Participant>[
    Participant(name: 'A', surname: 'A', email: 'a@x.com'),
  ];

  group('RaffleRequestModel.toJson', () {
    test('omits the gifts key for new-year raffles', () {
      final Map<String, dynamic> json = const RaffleRequestModel(
        config: config,
        participants: participants,
      ).toJson();

      expect(json['title'], 'Ofis');
      expect(json['group'], 10);
      expect(json['sector'], 20);
      expect(json['participants'], hasLength(1));
      expect((json['participants'] as List).first, const <String, dynamic>{
        'name': 'A',
        'surname': 'A',
        'email': 'a@x.com',
      });
      expect(json.containsKey('gifts'), isFalse);
    });

    test('includes gifts with the backend gift id when present', () {
      final Map<String, dynamic> json = const RaffleRequestModel(
        config: config,
        participants: participants,
        gifts: <Gift>[Gift(name: 'Kupa', count: 3)],
      ).toJson();

      final Map<String, dynamic> gift =
          (json['gifts'] as List).first as Map<String, dynamic>;
      expect(gift['giftId'], AppConstants.defaultGiftId);
      expect(gift['name'], 'Kupa');
      expect(gift['count'], 3);
    });
  });

  group('StatisticsModel.fromJson', () {
    test('maps noelRaffleCount to newYearRaffleCount', () {
      final StatisticsModel stats =
          StatisticsModel.fromJson(const <String, dynamic>{
        'noelRaffleCount': 4,
        'giftRaffleCount': 6,
        'participantCount': 30,
        'giftCount': 12,
        'totalRaffleCount': 10,
      });

      expect(stats.newYearRaffleCount, 4);
      expect(stats.giftRaffleCount, 6);
      expect(stats.participantCount, 30);
      expect(stats.giftCount, 12);
      expect(stats.totalRaffleCount, 10);
    });

    test('defaults missing fields to zero', () {
      final StatisticsModel stats =
          StatisticsModel.fromJson(const <String, dynamic>{});
      expect(stats.totalRaffleCount, 0);
    });
  });
}
