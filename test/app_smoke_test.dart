import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:noel_raffle/app/app.dart';
import 'package:noel_raffle/core/constants/app_constants.dart';
import 'package:noel_raffle/core/di/injection.dart';
import 'package:noel_raffle/l10n/app_localizations.dart';
import 'package:noel_raffle/presentation/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await GetIt.instance.reset();
    await configureDependencies();
  });

  testWidgets('boots to splash then navigates to the home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NoelRaffleApp());

    // Splash shows the brand name (identical in every locale).
    expect(find.text('Noel Raffle'), findsOneWidget);

    // Fire the splash timer and let navigation settle.
    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();

    // Home offers a button for each raffle type, in the active locale.
    final AppLocalizations l10n =
        AppLocalizations.of(tester.element(find.byType(HomeScreen)));
    expect(
      find.widgetWithText(ElevatedButton, l10n.newYearRaffle),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(ElevatedButton, l10n.giftRaffle),
      findsOneWidget,
    );
  });
}
