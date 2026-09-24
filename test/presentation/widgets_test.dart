import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/core/theme/app_theme.dart';
import 'package:noel_raffle/domain/entities/draw_assignment.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/entities/raffle_config.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:noel_raffle/l10n/app_localizations.dart';
import 'package:noel_raffle/presentation/widgets/app_button.dart';
import 'package:noel_raffle/presentation/widgets/initials_avatar.dart';
import 'package:noel_raffle/presentation/widgets/result_share_card.dart';
import 'package:noel_raffle/presentation/widgets/step_header.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(body: child),
      ),
    );
  }

  group('InitialsAvatar.initialsOf', () {
    test('uses the first and last word', () {
      expect(InitialsAvatar.initialsOf('Ayşe Nur Kaya'), 'AK');
      expect(InitialsAvatar.initialsOf('  cem  '), 'C');
    });

    test('falls back for a blank name', () {
      expect(InitialsAvatar.initialsOf('   '), '?');
    });
  });

  group('AppButton', () {
    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      int taps = 0;
      await pump(tester, AppButton(label: 'Go', onPressed: () => taps++));
      await tester.tap(find.text('Go'));
      expect(taps, 1);
    });

    testWidgets('shows a spinner and ignores taps while loading',
        (WidgetTester tester) async {
      int taps = 0;
      await pump(
        tester,
        AppButton(label: 'Go', loading: true, onPressed: () => taps++),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.text('Go'));
      expect(taps, 0);
    });
  });

  testWidgets('StepHeader counts the steps of the raffle type',
      (WidgetTester tester) async {
    await pump(
      tester,
      const StepHeader(
        type: RaffleType.gift,
        step: 2,
        title: 'Participants',
        subtitle: 'Add people',
      ),
    );
    expect(find.text('Step 2 of 3'), findsOneWidget);
    expect(find.text('Participants'), findsOneWidget);
  });

  group('ResultShareCard', () {
    final Raffle raffle = Raffle(
      id: 'r',
      config: const RaffleConfig(title: 'Office', type: RaffleType.newYear),
      createdAt: DateTime.utc(2026, 12, 24),
      assignments: const <DrawAssignment>[
        DrawAssignment(participant: Participant(name: 'Ann'), match: 'Bob'),
        DrawAssignment(
          participant: Participant(name: 'Bob', wish: 'A scarf'),
          match: 'Ann',
        ),
      ],
    );

    testWidgets('shows the match and the giftee\'s ideas',
        (WidgetTester tester) async {
      await pump(
        tester,
        SingleChildScrollView(
          child: ResultShareCard(
            raffle: raffle,
            assignment: raffle.assignments.first,
          ),
        ),
      );
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('A scarf'), findsOneWidget);
    });

    testWidgets('shows only the code once published',
        (WidgetTester tester) async {
      await pump(
        tester,
        SingleChildScrollView(
          child: ResultShareCard(
            raffle: raffle,
            assignment: raffle.assignments.first.withCode('ABCDEFGH'),
          ),
        ),
      );
      expect(find.text('ABCD-EFGH'), findsOneWidget);
      expect(find.text('Bob'), findsNothing);
    });
  });
}
