import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:noel_raffle/core/constants/app_assets.dart';
import 'package:noel_raffle/core/constants/app_constants.dart';
import 'package:noel_raffle/core/di/injection.dart';
import 'package:noel_raffle/core/l10n/locale_cubit.dart';
import 'package:noel_raffle/core/theme/app_dimens.dart';
import 'package:noel_raffle/core/theme/app_theme.dart';
import 'package:noel_raffle/core/theme/theme_cubit.dart';
import 'package:noel_raffle/domain/entities/draw_assignment.dart';
import 'package:noel_raffle/domain/entities/gift.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/entities/raffle_config.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:noel_raffle/domain/repositories/raffle_history_repository.dart';
import 'package:noel_raffle/l10n/app_localizations.dart';
import 'package:noel_raffle/presentation/screens/history/history_screen.dart';
import 'package:noel_raffle/presentation/screens/home/home_screen.dart';
import 'package:noel_raffle/presentation/screens/participants/participants_screen.dart';
import 'package:noel_raffle/presentation/screens/raffle_result/raffle_result_screen.dart';
import 'package:noel_raffle/presentation/screens/settings/settings_screen.dart';
import 'package:noel_raffle/presentation/screens/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'store_locale.dart';

/// Decodes the app illustrations for real (widget tests fake async work), so
/// the next frame shows them. [within] locates any widget in the tree.
Future<void> precacheIllustrations(WidgetTester tester, Finder within) async {
  await tester.runAsync(() {
    final BuildContext context = tester.element(within);
    return Future.wait(<Future<void>>[
      for (final String asset in AppAssets.illustrations)
        precacheImage(AssetImage(asset), context),
    ]);
  });
}

/// An app screen as it appears on the phone, and whether it is dark.
typedef PhoneScreen = ({ui.Image image, bool dark});

/// Drives the real app into the state each screenshot shows and captures
/// it at phone resolution (390 × 844 pt at 3x, with status and gesture bar
/// insets).
class AppScenes {
  AppScenes(this.tester, this.store)
      : l10n = lookupAppLocalizations(store.locale);

  static const Size phoneSize = Size(390, 844);
  static const double _pixelRatio = 3;

  final WidgetTester tester;
  final StoreLocale store;
  final AppLocalizations l10n;
  final GlobalKey _boundary = GlobalKey();
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  /// The screens behind [shot]: one phone, or two side by side.
  Future<List<PhoneScreen>> capture(StoreShot shot) async {
    return switch (shot) {
      StoreShot.home => <PhoneScreen>[
          await _render(const HomeScreen(), dark: false),
        ],
      StoreShot.participants => <PhoneScreen>[
          await _render(
            ParticipantsScreen(config: _config(RaffleType.newYear)),
            dark: false,
            interact: _addParticipants,
          ),
        ],
      StoreShot.reveal => <PhoneScreen>[
          await _render(
            RaffleResultScreen(raffle: _newYearRaffle()),
            dark: true,
            interact: () => _reveal(store.names[1], hide: false),
          ),
        ],
      StoreShot.progress => <PhoneScreen>[
          await _render(
            RaffleResultScreen(raffle: _newYearRaffle()),
            dark: false,
            interact: () async {
              await _reveal(store.names[0]);
              await _reveal(store.names[2]);
            },
          ),
        ],
      StoreShot.prizes => <PhoneScreen>[
          await _render(RaffleResultScreen(raffle: _giftRaffle()), dark: true),
        ],
      StoreShot.personalize => <PhoneScreen>[
          await _render(const SettingsScreen(), dark: false),
          await _render(
            const HistoryScreen(),
            dark: true,
            seed: _saveHistory,
          ),
        ],
    };
  }

  /// The splash screen, captured once its intro animation has played.
  Future<PhoneScreen> splash() async {
    await _pumpApp(home: const SplashScreen(), dark: false);
    await tester.pump(AppMotion.slow);
    final ui.Image image = await _capture();
    // Lets the splash timer fire and hand over to the home screen.
    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();
    // The splash is drawn on the dark brand gradient.
    return (image: image, dark: true);
  }

  Future<PhoneScreen> _render(
    Widget screen, {
    required bool dark,
    Future<void> Function()? seed,
    Future<void> Function()? interact,
  }) async {
    await _pumpApp(home: const HomeScreen(), dark: dark, seed: seed);
    // Opened from home, like in the app, so the app bar shows a back button.
    if (screen is! HomeScreen) {
      _navigator.currentState!
          .push(MaterialPageRoute<void>(builder: (_) => screen));
    }
    // Lets asynchronous loads (history, statistics) finish.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    await interact?.call();
    await tester.pumpAndSettle();
    return (image: await _capture(), dark: dark);
  }

  /// Starts the app from an empty store with [home] as the first screen.
  Future<void> _pumpApp({
    required Widget home,
    required bool dark,
    Future<void> Function()? seed,
  }) async {
    tester.view
      ..physicalSize = phoneSize * _pixelRatio
      ..devicePixelRatio = _pixelRatio
      ..padding = const FakeViewPadding(top: 47 * 3, bottom: 34 * 3)
      ..viewPadding = const FakeViewPadding(top: 47 * 3, bottom: 34 * 3);

    // Each scene starts from an empty, in-memory store, as in widget tests.
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await GetIt.instance.reset();
    await configureDependencies();
    await tester.runAsync(() async => seed?.call());
    await sl<ThemeCubit>().setMode(dark ? ThemeMode.dark : ThemeMode.light);
    await sl<LocaleCubit>().setLocale(store.locale);

    await tester.pumpWidget(
      RepaintBoundary(
        key: _boundary,
        child: MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<ThemeCubit>.value(value: sl<ThemeCubit>()),
            BlocProvider<LocaleCubit>.value(value: sl<LocaleCubit>()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: dark ? ThemeMode.dark : ThemeMode.light,
            locale: store.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            navigatorKey: _navigator,
            home: home,
          ),
        ),
      ),
    );
    await precacheIllustrations(tester, find.byType(MaterialApp));
  }

  Future<ui.Image> _capture() async {
    final RenderRepaintBoundary boundary =
        _boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    return (await tester.runAsync(
      () => boundary.toImage(pixelRatio: _pixelRatio),
    ))!;
  }

  Future<void> _tapText(String text) async {
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  Future<void> _addParticipants() async {
    for (int i = 0; i < 4; i++) {
      await _tapText(l10n.addParticipant);
      await tester.enterText(
        find.widgetWithText(TextField, l10n.name),
        store.names[i],
      );
      if (i == 0) {
        await tester.enterText(
          find.widgetWithText(TextField, l10n.emailOptional),
          store.email,
        );
      }
      await _tapText(l10n.add);
    }
  }

  /// Walks through the pass-the-phone reveal of [name]'s result.
  Future<void> _reveal(String name, {bool hide = true}) async {
    await _tapText(name);
    await _tapText(l10n.reveal);
    if (hide) await _tapText(l10n.hide);
  }

  RaffleConfig _config(RaffleType type, {String? title}) {
    return RaffleConfig(
      title: title ?? (type.isNewYear ? store.newYearTitle : store.giftTitle),
      note: store.note,
      type: type,
    );
  }

  List<Participant> get _participants => <Participant>[
        for (int i = 0; i < store.names.length; i++)
          Participant(
            name: store.names[i],
            email: i == 0 ? store.email : null,
          ),
      ];

  /// A Secret Santa circle: everyone gives to the person two places on.
  Raffle _newYearRaffle({String? title, DateTime? createdAt}) {
    final List<Participant> people = _participants;
    return Raffle(
      id: 'store-new-year-${title ?? ''}',
      config: _config(RaffleType.newYear, title: title),
      createdAt: createdAt ?? DateTime(2026, 12, 24, 19, 30),
      assignments: <DrawAssignment>[
        for (int i = 0; i < people.length; i++)
          DrawAssignment(
            participant: people[i],
            match: people[(i + 2) % people.length].name,
          ),
      ],
    );
  }

  Raffle _giftRaffle({String? title, DateTime? createdAt}) {
    final List<String?> prizes = <String?>[
      store.gifts[1],
      null,
      store.gifts[0],
      store.gifts[2],
      null,
    ];
    final List<Participant> people = _participants;
    return Raffle(
      id: 'store-gift-${title ?? ''}',
      config: _config(RaffleType.gift, title: title),
      createdAt: createdAt ?? DateTime(2026, 12, 20, 18),
      assignments: <DrawAssignment>[
        for (int i = 0; i < people.length; i++)
          DrawAssignment(participant: people[i], match: prizes[i]),
      ],
      gifts: <Gift>[
        for (final String gift in store.gifts) Gift(name: gift, count: 1)
      ],
    );
  }

  Future<void> _saveHistory() async {
    final RaffleHistoryRepository history = sl<RaffleHistoryRepository>();
    for (final Raffle raffle in <Raffle>[
      _giftRaffle(
        title: store.pastTitles[1],
        createdAt: DateTime(2026, 11, 14, 20),
      ),
      _newYearRaffle(
        title: store.pastTitles[0],
        createdAt: DateTime(2025, 12, 31, 21),
      ),
      _giftRaffle(),
      _newYearRaffle(),
    ]) {
      await history.save(raffle);
    }
  }
}
