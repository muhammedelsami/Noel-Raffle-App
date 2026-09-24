import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/core/l10n/raffle_texts.dart';
import 'package:noel_raffle/domain/entities/draw_assignment.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/entities/raffle_config.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:noel_raffle/l10n/app_localizations.dart';

void main() {
  final AppLocalizations l10n = lookupAppLocalizations(const Locale('en'));

  final Raffle raffle = Raffle(
    id: 'r',
    config: const RaffleConfig(title: 'Office', type: RaffleType.newYear),
    createdAt: DateTime.utc(2026, 12, 24),
    assignments: const <DrawAssignment>[
      DrawAssignment(participant: Participant(name: 'Ann'), match: 'Bob'),
      DrawAssignment(
        participant: Participant(name: 'Bob', wish: 'A scarf'),
        match: 'Cid',
      ),
      DrawAssignment(participant: Participant(name: 'Cid'), match: 'Ann'),
    ],
  );

  test('a Secret Santa message carries the giftee\'s gift ideas', () {
    final String message =
        participantMessage(l10n, raffle, raffle.assignments.first);
    expect(message, contains('Bob'));
    expect(message, contains(l10n.shareWishLine('A scarf')));
  });

  test('no gift ideas line when the giftee left none', () {
    final String message =
        participantMessage(l10n, raffle, raffle.assignments[1]);
    expect(message, isNot(contains(l10n.shareWishLine(''))));
  });

  test('a coded message never reveals the match or their wishes', () {
    final DrawAssignment coded = raffle.assignments.first.withCode('ABCDEFGH');
    final String message = participantMessage(l10n, raffle, coded);
    expect(message, isNot(contains('A scarf')));
  });
}
