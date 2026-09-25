import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:noel_raffle/core/l10n/raffle_texts.dart';
import 'package:noel_raffle/domain/entities/draw_assignment.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/entities/raffle_config.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:noel_raffle/l10n/app_localizations.dart';

void main() {
  final AppLocalizations l10n = lookupAppLocalizations(const Locale('en'));

  setUpAll(initializeDateFormatting);

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

  test('messages carry the gift day when there is one', () {
    final Raffle dated = Raffle(
      id: raffle.id,
      config: RaffleConfig(
        title: 'Office',
        type: RaffleType.newYear,
        note: 'Budget 20',
        eventDate: DateTime(2026, 12, 24),
      ),
      createdAt: raffle.createdAt,
      assignments: raffle.assignments,
    );
    final String day = giftDayLabel(l10n, DateTime(2026, 12, 24));
    expect(day, 'Thursday, December 24, 2026');
    final String message =
        participantMessage(l10n, dated, dated.assignments.first);
    expect(
      message,
      endsWith(
          '${l10n.shareDateLine(day)}\n\n${l10n.shareNoteLine('Budget 20')}'),
    );
    expect(
      participantMessage(l10n, raffle, raffle.assignments.first),
      isNot(contains(l10n.shareDateLine(''))),
    );
  });

  test('a coded message never reveals the match or their wishes', () {
    final DrawAssignment coded = raffle.assignments.first.withCode('ABCDEFGH');
    final String message = participantMessage(l10n, raffle, coded);
    expect(message, isNot(contains('A scarf')));
  });
}
