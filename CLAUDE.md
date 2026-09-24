# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter app (`noel_raffle`) for running raffles: a "new year" raffle (Secret Santa) and a
"gift" raffle (prizes handed out to random participants). There is **no backend**. The draw
runs on the device, and the history is stored locally. Firebase (free Spark plan:
Firestore + anonymous Auth) is optional and adds personal online result codes plus global
statistics. Without a configured Firebase project the app runs fully offline and hides those
features.

User-facing strings are localized (TR / EN / AR) in `lib/l10n/*.arb`. `app_en.arb` is the
template and holds the placeholder metadata. Run `flutter gen-l10n` after editing ARB files; the
generated `app_localizations*.dart` files are committed.

## Commands

```bash
flutter pub get                       # install deps
flutter run                           # run on connected device/emulator
flutter analyze                       # static analysis (config in analysis_options.yaml)
flutter test                          # run all tests
flutter test test/domain/raffle_drawer_test.dart       # single test file
flutter test --plain-name 'boots to splash'            # single test by name
flutter gen-l10n                      # regenerate localizations from lib/l10n/*.arb
dart run flutter_launcher_icons       # regenerate app icons from icons/noelapplogo.jpeg
flutterfire configure                 # connect a Firebase project (overwrites lib/firebase_options.dart)
firebase deploy --only firestore:rules  # deploy firebase/firestore.rules
```

Requires Dart SDK `>=3.2.3 <4.0.0` and a recent Flutter (3.44+). iOS deployment target is 15.0
(Firebase minimum).

## Architecture

Clean architecture with strict layer boundaries. Dependencies point inward: `presentation`
and `data` depend on `domain`; `domain` depends on nothing. `core` is cross-cutting.

- **`domain/`**: pure Dart, no Flutter/Firebase imports.
  - `entities/`: `Raffle` (config + `DrawAssignment`s + gifts), `Participant` (name + optional
    email), `Gift`, `SharedResult`, `Statistics`, `RaffleRules`.
  - `services/`: `RaffleDrawer` (the draw algorithm; inject a seeded `Random` in tests) and
    `ShareCode` (personal code generation/normalization).
  - `repositories/`: abstract interfaces.
  - `usecases/`: single-action classes with a `call(...)` method, e.g. `CreateRaffle`,
    `PublishRaffle`.
- **`data/`**: implements domain repositories.
  - `datasources/`: `RaffleLocalDataSource` (history as JSON in `SharedPreferences`) and
    `RaffleCloudDataSource` (Firestore).
  - `models/`: JSON DTOs. `Model.fromEntity(e).toJson()` serializes; the static
    `fromJson`/`fromFirestore` return the **plain entity**, never a model subclass. Equatable
    compares runtime types, and a reified `List<Model>` would reject plain entities.
  - `repositories/`: wire the datasources to the domain interfaces.
- **`presentation/`**: `cubit/` (one folder per cubit, `*_cubit.dart` + `*_state.dart` with
  `state` as a `part`), `screens/`, and reusable `widgets/`.
- **`core/`**: `di/injection.dart` (service locator), `firebase/` (optional init), `l10n/`
  (locale cubit, `raffle_texts.dart` for localized labels and share messages), `theme/`,
  `constants/`, `utils/` (`Validators`, `UrlLauncherHelper`, `ShareHelper`),
  `error/exceptions.dart`.

### RaffleType drives both flows
The two raffle variants are a single `RaffleType` enum (`newYear` / `gift`). Screens are shared.
The enum decides how the draw works, whether the gifts step exists (`type.hasGifts`), whether
results are secret, and which artwork to show. Prefer extending this enum over branching on
booleans or duplicating screens. Draw rules (minimum participants and gifts, at most one gift per
participant) live in `RaffleRules`. `RaffleDrawer` throws `RaffleRuleException`, and the UI maps
it with `ruleViolationMessage`.

### Optional Firebase
`main()` calls `initializeFirebase()`, which returns `false` when `lib/firebase_options.dart` is
still the placeholder or init fails. That flag goes to `configureDependencies(cloudEnabled:)`.
When it is off, `OnlineRaffleRepositoryImpl(null)` reports `isAvailable == false` and throws
`CloudUnavailableException`. The UI checks `isAvailable` on the relevant use case
(`LookupResult`, `PublishRaffle`, `GetGlobalStatistics`) to hide online features.
- `results/{code}`: one participant's result, readable only by its code. Emails are never
  uploaded.
- `stats/global`: counters incremented best-effort after each draw (fire-and-forget; never
  blocks or fails the draw).
- Any new field or collection must also be allowed in `firebase/firestore.rules`.

### Dependency injection (get_it)
`configureDependencies()` in `lib/core/di/injection.dart` runs once in `main()` before `runApp`.
Access anywhere via the global `sl<T>()`. Registration conventions:
- `registerSingleton` / `registerLazySingleton`: shared services and app-wide state
  (repositories, use cases, `ThemeCubit`, `LocaleCubit`).
- `registerFactory` / `registerFactoryParam`: per-screen cubits that need a fresh instance
  (`RaffleDrawCubit`, `RaffleResultCubit` with the raffle as `param1`, `HistoryCubit`, ...),
  provided via `BlocProvider`.
- Short-lived list-building cubits (participants/gifts) are **not** in get_it. They're created
  directly in their screen's `BlocProvider`.

### Navigation & theme
Single `MaterialApp` in `lib/app/app.dart`. Screens navigate with `Navigator.push`/`MaterialPageRoute`
(no named routes). Startup is `SplashScreen` → `HomeScreen`. After a draw,
`RaffleResultScreen.openAfterDraw` replaces the creation flow so "back" returns home.
Light/dark/system theme (`ThemeCubit`) and language (`LocaleCubit`) are provided at the root and
persisted to `SharedPreferences`.

## Conventions

- Lint rules in `analysis_options.yaml` are enforced: single quotes, explicit return types,
  `const` constructors, `prefer_final_locals`. Run `flutter analyze` before considering work done.
- Constants, input limits, asset paths, and colors/typography are centralized under
  `core/constants/` and `core/theme/`. Reference those rather than literals.
- Form dialogs show validation errors inline (`FormErrorText`), not as SnackBars. A SnackBar
  outlives the dialog and covers the screen's bottom buttons.
- Tests use `flutter_test` + `bloc_test`; Firestore code is tested with `fake_cloud_firestore` +
  `firebase_auth_mocks`. Cubit tests live in `test/presentation/`. Widget tests reset and re-run
  `configureDependencies()` with `SharedPreferences.setMockInitialValues` (see
  `test/app_flow_test.dart` for full UI flows).
