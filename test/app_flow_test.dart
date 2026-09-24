import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:noel_raffle/app/app.dart';
import 'package:noel_raffle/core/constants/app_constants.dart';
import 'package:noel_raffle/core/di/injection.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/usecases/get_raffle_history.dart';
import 'package:noel_raffle/l10n/app_localizations.dart';
import 'package:noel_raffle/presentation/screens/home/home_screen.dart';
import 'package:noel_raffle/presentation/screens/raffle_result/raffle_result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppLocalizations l10n;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await GetIt.instance.reset();
    await configureDependencies();
  });

  Future<void> bootToHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NoelRaffleApp());
    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();
    l10n = AppLocalizations.of(tester.element(find.byType(HomeScreen)));
  }

  Future<void> tapButton(WidgetTester tester, String label) async {
    await tester.tap(find.widgetWithText(ElevatedButton, label));
    await tester.pumpAndSettle();
  }

  Future<void> addParticipant(WidgetTester tester, String name) async {
    await tapButton(tester, l10n.addParticipant);
    await tester.enterText(find.widgetWithText(TextField, l10n.name), name);
    await tapButton(tester, l10n.add);
  }

  testWidgets('hides the online features without Firebase',
      (WidgetTester tester) async {
    await bootToHome(tester);
    expect(find.text(l10n.viewMyResult), findsNothing);
  });

  testWidgets('draws a new-year raffle offline and reveals one result',
      (WidgetTester tester) async {
    await bootToHome(tester);

    await tapButton(tester, l10n.newYearRaffle);
    await tester.enterText(
      find.widgetWithText(TextField, l10n.raffleTitleHint),
      'Ofis',
    );
    await tapButton(tester, l10n.createNewYearRaffle);

    // Too few people: the draw is refused.
    await addParticipant(tester, 'Ayşe');
    await addParticipant(tester, 'Burak');
    await tapButton(tester, l10n.startRaffle);
    expect(find.text(l10n.minParticipants(3)), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, l10n.ok));
    await tester.pumpAndSettle();

    // Duplicate names are rejected.
    await addParticipant(tester, 'ayşe');
    expect(find.text(l10n.nameAlreadyAdded), findsOneWidget);
    await tester.tapAt(const Offset(10, 10)); // dismiss the dialog
    await tester.pumpAndSettle();

    await addParticipant(tester, 'Cem');
    await tapButton(tester, l10n.startRaffle);

    expect(find.byType(RaffleResultScreen), findsOneWidget);
    expect(find.text(l10n.tapToReveal), findsNWidgets(3));

    // Pass-the-phone reveal.
    await tester.tap(find.text('Burak'));
    await tester.pumpAndSettle();
    expect(find.text(l10n.revealTitle('Burak')), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, l10n.reveal));
    await tester.pumpAndSettle();
    expect(find.text(l10n.greeting('Burak')), findsOneWidget);
    expect(find.text(l10n.yourGiftee), findsOneWidget);

    await tester.tap(find.text(l10n.hide));
    await tester.pumpAndSettle();
    expect(find.text(l10n.seen), findsOneWidget);
    expect(find.text(l10n.publishOnline), findsNothing);

    // The raffle was saved, and going back lands on the home screen.
    final List<Raffle> history = await sl<GetRaffleHistory>()();
    expect(history.single.title, 'Ofis');
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('draws a gift raffle and lists it in the history',
      (WidgetTester tester) async {
    await bootToHome(tester);

    await tapButton(tester, l10n.giftRaffle);
    await tester.enterText(
      find.widgetWithText(TextField, l10n.raffleTitleHint),
      'Yılbaşı Partisi',
    );
    await tapButton(tester, l10n.createGiftRaffle);
    for (final String name in <String>['Ayşe', 'Burak', 'Cem']) {
      await addParticipant(tester, name);
    }
    await tapButton(tester, l10n.next);

    await tapButton(tester, l10n.addGift);
    await tester.enterText(
        find.widgetWithText(TextField, l10n.giftName), 'Kupa');
    await tester.enterText(find.widgetWithText(TextField, l10n.giftCount), '2');
    await tapButton(tester, l10n.add);
    await tapButton(tester, l10n.startRaffle);

    // Gift results are public: two winners and one without a prize.
    expect(find.byType(RaffleResultScreen), findsOneWidget);
    expect(find.text('Kupa'), findsNWidgets(2));
    expect(find.text(l10n.noPrizeShort), findsOneWidget);
    expect(find.text(l10n.shareResults), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tapButton(tester, l10n.history);
    expect(find.text('Yılbaşı Partisi'), findsOneWidget);
  });
}
