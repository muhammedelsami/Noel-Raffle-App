import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/domain/entities/draw_assignment.dart';
import 'package:noel_raffle/domain/entities/draw_constraints.dart';
import 'package:noel_raffle/domain/entities/match_exclusion.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/entities/raffle_config.dart';
import 'package:noel_raffle/domain/entities/raffle_rules.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:noel_raffle/domain/services/previous_raffle.dart';
import 'package:noel_raffle/domain/services/raffle_drawer.dart';

List<Participant> people(int n) =>
    List<Participant>.generate(n, (int i) => Participant(name: 'P$i'));

Map<String, String> giftees(List<DrawAssignment> result) => <String, String>{
      for (final DrawAssignment a in result) a.participant.name: a.match!,
    };

Raffle newYearRaffle(Map<String, String> matches, {String id = 'r'}) => Raffle(
      id: id,
      config: const RaffleConfig(title: 'Ofis', type: RaffleType.newYear),
      createdAt: DateTime.utc(2025, 12, 31),
      assignments: <DrawAssignment>[
        for (final MapEntry<String, String> m in matches.entries)
          DrawAssignment(participant: Participant(name: m.key), match: m.value),
      ],
    );

void main() {
  group('MatchExclusion', () {
    const MatchExclusion rule = MatchExclusion('Ayşe', 'Burak');

    test('blocks both directions, ignoring case', () {
      expect(rule.blocks('Ayşe', 'Burak'), isTrue);
      expect(rule.blocks('burak', 'AYŞE'), isTrue);
      expect(rule.blocks('Ayşe', 'Cem'), isFalse);
    });

    test('recognises the same pair in any order', () {
      expect(rule.samePairAs(const MatchExclusion('burak', 'ayşe')), isTrue);
      expect(rule.samePairAs(const MatchExclusion('Ayşe', 'Cem')), isFalse);
    });

    test('follows a renamed participant', () {
      expect(rule.renamed('ayşe', 'Ayşe Nur'),
          const MatchExclusion('Ayşe Nur', 'Burak'));
    });
  });

  group('constrained new-year draw', () {
    test('never pairs people who must be kept apart', () {
      const List<MatchExclusion> rules = <MatchExclusion>[
        MatchExclusion('P0', 'P1'),
        MatchExclusion('P2', 'P3'),
      ];
      for (int seed = 0; seed < 200; seed++) {
        final int n = 4 + seed % 8;
        final Map<String, String> result = giftees(
          RaffleDrawer(random: Random(seed)).draw(
            type: RaffleType.newYear,
            participants: people(n),
            constraints: const DrawConstraints(exclusions: rules),
          ),
        );
        for (final MatchExclusion rule in rules) {
          expect(result[rule.first], isNot(rule.second));
          expect(result[rule.second], isNot(rule.first));
        }
        // Still one circle through everyone.
        String current = 'P0';
        final Set<String> visited = <String>{};
        while (visited.add(current)) {
          current = result[current]!;
        }
        expect(visited.length, n);
      }
    });

    test('avoids repeating last time\'s pairs', () {
      final Raffle lastYear = newYearRaffle(<String, String>{
        'P0': 'P1',
        'P1': 'P2',
        'P2': 'P3',
        'P3': 'P0',
      });
      for (int seed = 0; seed < 100; seed++) {
        final Map<String, String> result = giftees(
          RaffleDrawer(random: Random(seed)).draw(
            type: RaffleType.newYear,
            participants: people(4),
            constraints: DrawConstraints.avoiding(lastYear),
          ),
        );
        for (final DrawAssignment a in lastYear.assignments) {
          expect(result[a.participant.name], isNot(a.match));
        }
      }
    });

    test('reports rules that leave no valid circle', () {
      // With three people every circle includes P0 and P1 as neighbours.
      expect(
        () => RaffleDrawer().draw(
          type: RaffleType.newYear,
          participants: people(3),
          constraints: const DrawConstraints(
            exclusions: <MatchExclusion>[MatchExclusion('P0', 'P1')],
          ),
        ),
        throwsA(isA<RaffleRuleException>().having(
          (RaffleRuleException e) => e.violation,
          'violation',
          RaffleRuleViolation.noValidMatch,
        )),
      );
    });
  });

  group('findPreviousRaffle', () {
    final Raffle office = newYearRaffle(
      <String, String>{'P0': 'P1', 'P1': 'P2', 'P2': 'P0'},
      id: 'office',
    );

    test('finds the newest raffle sharing at least two people', () {
      expect(findPreviousRaffle(<Raffle>[office], people(4)), office);
    });

    test('ignores raffles of a different group', () {
      expect(
        findPreviousRaffle(
          <Raffle>[office],
          const <Participant>[
            Participant(name: 'P0'),
            Participant(name: 'Other'),
          ],
        ),
        isNull,
      );
    });
  });
}
