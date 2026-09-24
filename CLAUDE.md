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
dart run flutter_launcher_icons:main  # regenerate app icons from icons/app_icon*.png
flutterfire configure                 # connect a Firebase project (writes the gitignored lib/firebase_options.dart)
firebase deploy --only firestore:rules  # deploy firebase/firestore.rules
flutter test Production/tool/store_assets.dart  # regenerate the Play Store artwork (see Production/README.md)
```

Requires Dart SDK `>=3.2.3 <4.0.0` and a recent Flutter (3.44+). iOS deployment target is 15.0
(Firebase minimum).

## Architecture

Clean architecture with strict layer boundaries. Dependencies point inward: `presentation`
and `data` depend on `domain`; `domain` depends on nothing. `core` is cross-cutting.

- **`domain/`**: pure Dart, no Flutter/Firebase imports.
  - `entities/`: `Raffle` (`RaffleConfig` + `DrawAssignment`s + gifts + `MatchExclusion`s),
    `RaffleConfig` (title, note, type, optional gift day `eventDate` and `remind`),
    `Participant` (name + optional email and gift ideas `wish`), `Gift`, `SharedResult`,
    `Statistics`, `RaffleRules`, `DrawConstraints` (exclusions + last time's pairs),
    `RaffleDraft` (what "draw again" prefills).
  - `services/`: `RaffleDrawer` (the draw algorithm; inject a seeded `Random` in tests),
    `ShareCode` (personal code generation/normalization) and `findPreviousRaffle`.
  - `repositories/`: abstract interfaces, including `ReminderScheduler` (local notifications).
  - `usecases/`: single-action classes with a `call(...)` method, e.g. `CreateRaffle`,
    `PublishRaffle`, `ScheduleReminder`.
- **`data/`**: implements domain repositories.
  - `datasources/`: `RaffleLocalDataSource` (history as JSON in `SharedPreferences`) and
    `RaffleCloudDataSource` (Firestore).
  - `models/`: JSON DTOs. Calendar days (the gift day) are stored as `yyyy-MM-dd` via
    `DateOnly`. `Model.fromEntity(e).toJson()` serializes; the static
    `fromJson`/`fromFirestore` return the **plain entity**, never a model subclass. Equatable
    compares runtime types, and a reified `List<Model>` would reject plain entities.
  - `repositories/`: wire the datasources to the domain interfaces.
- **`presentation/`**: `cubit/` (one folder per cubit, `*_cubit.dart` + `*_state.dart` with
  `state` as a `part`), `screens/`, and reusable `widgets/`.
- **`core/`**: `di/injection.dart` (service locator), `firebase/` (optional init), `l10n/`
  (locale cubit, `raffle_texts.dart` for localized labels, dates and share messages), `theme/`
  (see Design system), `constants/`, `utils/` (`Validators`, `UrlLauncherHelper`,
  `ShareHelper` for text and PNG shares, `ParticipantListParser` for pasted lists),
  `notifications/` (`LocalReminderScheduler`), `review/` (`ReviewPrompter`),
  `error/exceptions.dart`.

### RaffleType drives both flows
The two raffle variants are a single `RaffleType` enum (`newYear` / `gift`). Screens are shared.
The enum decides how the draw works, whether the gifts step exists (`type.hasGifts`) and whether
results are secret. Its look (icon, illustration, accent colors, number of creation steps) lives
in the `RaffleTypeStyle` extension in `core/theme/raffle_type_style.dart`, so the domain stays
Flutter-free. Prefer extending the enum or that extension over branching on booleans or
duplicating screens. Draw rules (minimum participants and gifts, at most one gift per
participant) live in `RaffleRules`. `RaffleDrawer` throws `RaffleRuleException`, and the UI maps
it with `ruleViolationMessage`. New-year draws take `DrawConstraints`: the circle is then found
by a bounded randomized search, which throws `noValidMatch` when the rules leave no circle.

### Gift day reminders
The setup screen can set a gift day and "remind me the day before". Turning the switch on asks
for notification permission through `ScheduleReminder.requestPermission`. After a successful
draw `RaffleDrawListener` schedules the reminder (fire-and-forget) at 10:00 the day before, or
9:00 on the day. `DeleteRaffle` cancels it. `LocalReminderScheduler` wraps
flutter_local_notifications: it initializes lazily, schedules in UTC (no time zone database),
and uses inexact alarms, so no exact-alarm permission is needed. The native setup (desugaring,
the scheduled notification receivers, `RECEIVE_BOOT_COMPLETED`, `drawable/ic_notification.xml`
kept by `res/raw/keep.xml`, and the iOS notification center delegate) must stay in place.
Tests swap the scheduler for `test/fakes/recording_reminders.dart`.

### Optional Firebase
`main()` calls `initializeFirebase()`, which returns `false` when `lib/firebase_options.dart` is
still the placeholder or init fails. That flag goes to `configureDependencies(cloudEnabled:)`.
When it is off, `OnlineRaffleRepositoryImpl(null)` reports `isAvailable == false` and throws
`CloudUnavailableException`. The UI checks `isAvailable` on the relevant use case
(`LookupResult`, `PublishRaffle`, `GetGlobalStatistics`) to hide online features.
- `lib/firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist` and
  `.firebaserc` are gitignored and must never be committed. A fresh clone copies
  `lib/firebase_options.dart.example` or runs `flutterfire configure` (see README for the files
  to restore afterwards).
- `results/{code}`: one participant's result, readable only by its code: title, note, gift
  day, name, match and (new-year) the match's gift ideas. Emails are never uploaded.
- `stats/global`: counters incremented best-effort after each draw (fire-and-forget; never
  blocks or fails the draw).
- Any new field or collection must also be allowed in `firebase/firestore.rules`.

### Dependency injection (get_it)
`configureDependencies()` in `lib/core/di/injection.dart` runs once in `main()` before `runApp`.
Access anywhere via the global `sl<T>()`. Registration conventions:
- `registerSingleton` / `registerLazySingleton`: shared services and app-wide state
  (repositories, use cases, `ReminderScheduler`, `ReviewPrompter`, `ThemeCubit`,
  `LocaleCubit`).
- `registerFactory` / `registerFactoryParam`: per-screen cubits that need a fresh instance
  (`RaffleDrawCubit`, `RaffleResultCubit` with the raffle as `param1`, `HistoryCubit`, ...),
  provided via `BlocProvider`.
- Short-lived list-building cubits (participants/gifts) are **not** in get_it. They're created
  directly in their screen's `BlocProvider`.

### Navigation & theme
Single `MaterialApp` in `lib/app/app.dart`. Screens navigate with `Navigator.push`/`MaterialPageRoute`
(no named routes). Startup is `SplashScreen` (precaches the illustrations) → `HomeScreen`. The
creation flow is setup → participants → (gifts); after a draw (with a short
`showDrawAnimation`), `RaffleResultScreen.openAfterDraw` replaces it so "back" returns home.
Leaving that fresh result counts towards the one-time store review prompt (`ReviewPrompter`).
`RaffleSetupScreen.again` starts a new raffle prefilled from an old one. `SettingsScreen` holds the theme and language pickers and
links to history, statistics and about. Light/dark/system theme (`ThemeCubit`) and language
(`LocaleCubit`) are provided at the root and persisted to `SharedPreferences`.

### Design system
- **Tokens** (`core/theme/`): `AppColors` holds hand-tuned light/dark `ColorScheme`s (cranberry,
  evergreen, gold over warm neutrals); `BrandColors` is a `ThemeExtension` for colors without a
  scheme role (hero gradient, card border, avatar palette); `AppSpacing`, `AppRadius` and
  `AppMotion` in `app_dimens.dart`; `AppTypography` is the type scale on the single variable
  Google Font Alexandria (Latin, Turkish and Arabic), bundled in `assets/fonts/` with its OFL
  license (registered in `main()`). `AppTheme.light`/`dark` are built once and hold every
  component theme. Read them with `context.colors`, `context.textTheme` and `context.brand`
  (`theme_context.dart`).
- **Building blocks** (`presentation/widgets/`): `PageScaffold` (app bar, width-capped body,
  bottom action bar that stays above the keyboard), `AppButton` (primary/tonal/outlined/text,
  with `loading`), `AppCard`, `AppListTile`, `StepHeader`, `EditableListBody`, `EmptyState`,
  `InfoBanner`, `StatusPill`/`CountPill`, `IconBadge`, `InitialsAvatar`, `FormDialog`,
  `ResultCard`, `ResultShareCard` (the PNG card, always light), `NoteLine`, `TileGroup`,
  `EqualHeightRow`, `showUndoSnackBar`. Compose screens from these instead of styling Material
  widgets inline.
- **Wide screens**: content is capped at `AppConstants.maxContentWidth`. From
  `wideLayoutBreakpoint` (`ContentWidth.isWide`), card screens (home, statistics) use
  `maxWideContentWidth` and place cards side by side.
- **`BrandMark`** is the app logo, painted in code. The launcher icons in `icons/` are rendered
  from the same `BrandMarkPainter`; regenerate the platform icons with
  `dart run flutter_launcher_icons:main`, then restore the `<monochrome>` line in
  `mipmap-anydpi-v26/launcher_icon.xml` (the themed icon layer and the notification icon are
  hand-traced vectors in `android/app/src/main/res/drawable/`). Native launch screens use the brand color
  (`android/.../values*/colors.xml`, iOS `LaunchBackground` color set) to avoid a white flash.

### CI/CD
`.github/workflows/ci.yml` runs analyze, tests and a debug Android build on pull requests
without secrets.
`release.yml` builds a signed app bundle on push: `dev` goes to the Play internal track,
`main` to production. The version comes from the run number (never commit a bumped build
number); only major/minor in `pubspec.yaml` are edited by hand. Secrets live in the
`play-store` environment, limited to `dev` and `main`; never echo them or add
`pull_request_target` triggers.

## Conventions

- Lint rules in `analysis_options.yaml` are enforced: single quotes, explicit return types,
  `const` constructors, `prefer_final_locals`. Run `flutter analyze` before considering work done.
- Constants, input limits, asset paths, and colors/typography/spacing are centralized under
  `core/constants/` and `core/theme/`. Reference those rather than literals.
- Every text/background pair must meet WCAG AA (4.5:1) in both themes;
  `test/core/theme_test.dart` checks the scheme and brand colors. Use `EdgeInsetsDirectional`
  and direction-aware icons so Arabic (RTL) mirrors correctly.
- Keep screens cheap to build: lazy lists (`ListView.builder`/slivers) with keys, `context.select`
  or `BlocBuilder` scoped to what changes, and `RepaintBoundary` around continuous animations.
- Form dialogs show validation errors inline (`FormErrorText`), not as SnackBars. A SnackBar
  outlives the dialog and covers the screen's bottom buttons.
- Tests use `flutter_test` + `bloc_test`; Firestore code is tested with `fake_cloud_firestore` +
  `firebase_auth_mocks`. Cubit tests live in `test/presentation/`. Widget tests reset and re-run
  `configureDependencies()` with `SharedPreferences.setMockInitialValues` (see
  `test/app_flow_test.dart` for full UI flows).
