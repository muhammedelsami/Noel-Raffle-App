import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:noel_raffle/app/app.dart';
import 'package:noel_raffle/core/constants/app_constants.dart';
import 'package:noel_raffle/core/constants/app_strings.dart';
import 'package:noel_raffle/core/di/injection.dart';
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

    // Splash shows the brand name.
    expect(find.text(AppStrings.appName), findsOneWidget);

    // Fire the splash timer and let navigation settle.
    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();

    // Home offers a button for each raffle type.
    expect(
      find.widgetWithText(ElevatedButton, AppStrings.newYearRaffle),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(ElevatedButton, AppStrings.giftRaffle),
      findsOneWidget,
    );
  });
}
