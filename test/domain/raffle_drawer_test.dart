import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/domain/entities/draw_assignment.dart';
import 'package:noel_raffle/domain/entities/gift.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/domain/entities/raffle_rules.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:noel_raffle/domain/services/raffle_drawer.dart';

List<Participant> people(int n) =>
    List<Participant>.generate(n, (int i) => Participant(name: 'P$i'));

void main() {
  group('new-year draw', () {
    test('everyone gives to exactly one other person, never themselves', () {
      for (int seed = 0; seed < 200; seed++) {
        final int n = 3 + seed % 10;
        final List<Participant> participants = people(n);
        final List<DrawAssignment> result = RaffleDrawer(random: Random(seed))
            .draw(type: RaffleType.newYear, participants: participants);

        expect(result.map((DrawAssignment a) => a.participant), participants,
            reason: 'keeps the entry order');
        for (final DrawAssignment a in result) {
          expect(a.match, isNot(a.participant.name));
        }
        expect(
          result.map((DrawAssignment a) => a.match).toSet(),
          participants.map((Participant p) => p.name).toSet(),
          reason: 'every participant receives exactly one gift',
        );
      }
    });

    test('forms a single circle, so no two people swap with each other', () {
      for (int seed = 0; seed < 200; seed++) {
        final int n = 3 + seed % 10;
        final List<DrawAssignment> result = RaffleDrawer(random: Random(seed))
            .draw(type: RaffleType.newYear, participants: people(n));
        final Map<String, String> giftee = <String, String>{
          for (final DrawAssignment a in result) a.participant.name: a.match!,
        };

        String current = 'P0';
        final Set<String> visited = <String>{};
        while (visited.add(current)) {
          current = giftee[current]!;
        }
        expect(visited.length, n);
      }
    });

    test('rejects fewer than the minimum participants', () {
      expect(
        () => RaffleDrawer()
            .draw(type: RaffleType.newYear, participants: people(2)),
        throwsA(isA<RaffleRuleException>().having(
          (RaffleRuleException e) => e.violation,
          'violation',
          RaffleRuleViolation.notEnoughParticipants,
        )),
      );
    });
  });

  group('gift draw', () {
    const List<Gift> gifts = <Gift>[
      Gift(name: 'Kupa', count: 2),
      Gift(name: 'Kitap', count: 1),
    ];

    test('hands out every gift item to different participants', () {
      for (int seed = 0; seed < 200; seed++) {
        final List<DrawAssignment> result = RaffleDrawer(random: Random(seed))
            .draw(type: RaffleType.gift, participants: people(5), gifts: gifts);

        final List<String> won = result
            .map((DrawAssignment a) => a.match)
            .whereType<String>()
            .toList()
          ..sort();
        expect(won, <String>['Kitap', 'Kupa', 'Kupa']);
        expect(
            result.where((DrawAssignment a) => a.match == null), hasLength(2));
      }
    });

    test('allows exactly as many gift items as participants', () {
      final List<DrawAssignment> result = RaffleDrawer().draw(
        type: RaffleType.gift,
        participants: people(3),
        gifts: gifts,
      );
      expect(result.every((DrawAssignment a) => a.match != null), isTrue);
    });

    test('rejects more gift items than participants', () {
      expect(
        () => RaffleDrawer().draw(
          type: RaffleType.gift,
          participants: people(3),
          gifts: const <Gift>[Gift(name: 'Kupa', count: 4)],
        ),
        throwsA(isA<RaffleRuleException>().having(
          (RaffleRuleException e) => e.violation,
          'violation',
          RaffleRuleViolation.tooManyGifts,
        )),
      );
    });

    test('rejects a gift raffle without gifts', () {
      expect(
        RaffleRules.validate(type: RaffleType.gift, participants: people(3)),
        RaffleRuleViolation.notEnoughGifts,
      );
    });
  });
}
