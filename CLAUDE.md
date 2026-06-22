# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter app (`noel_raffle`) for creating raffles — a "new year" raffle and a "gift" raffle.
It collects a title/group/sector, a list of participants, and (for gift raffles) a list of
gifts, then POSTs them to the `noelraffle.com` backend. User-facing strings are Turkish
(see `lib/core/constants/app_strings.dart`); keep new copy in that file rather than inline.

## Commands

```bash
flutter pub get                       # install deps
flutter run                           # run on connected device/emulator
flutter analyze                       # static analysis (config in analysis_options.yaml)
flutter test                          # run all tests
flutter test test/core/validators_test.dart            # single test file
flutter test --plain-name 'boots to splash'            # single test by name
dart run flutter_launcher_icons       # regenerate app icons from icons/noelapplogo.jpeg
```

Requires Dart SDK `>=3.2.3 <4.0.0`. The pinned Flutter is recent (3.44-era; see commit history
referencing build-compat fixes) — Android build config in `android/` was adjusted for it.

## Architecture

Clean architecture with strict layer boundaries. Dependencies point inward: `presentation`
and `data` depend on `domain`; `domain` depends on nothing. `core` is cross-cutting.

- **`domain/`** — pure Dart, no Flutter/http imports. `entities/` (e.g. `RaffleConfig`,
  `Participant`, `Gift`, `Statistics`), `repositories/` (abstract interfaces), `usecases/`
  (single-action classes with a `call(...)` method, e.g. `CreateRaffle`, `GetStatistics`).
- **`data/`** — implements domain repositories. `datasources/` call the API via `ApiClient`;
  `models/` are JSON DTOs that convert to/from domain entities (`Model.fromEntity` / `toJson`);
  `repositories/` wire datasources to domain interfaces.
- **`presentation/`** — `cubit/` (one folder per cubit, `*_cubit.dart` + `*_state.dart` with
  `state` as a `part`), `screens/`, and reusable `widgets/`.
- **`core/`** — `di/injection.dart` (service locator), `network/`, `theme/`, `constants/`,
  `utils/` (`Validators`, `UrlLauncherHelper`), `error/exceptions.dart`.

### RaffleType drives both flows
The two raffle variants are a single `RaffleType` enum (`newYear` / `gift`). Screens are shared;
the enum decides which endpoint to hit, whether the gifts step exists (`type.hasGifts`), and
which artwork to show. Prefer extending this enum over branching on booleans or duplicating screens.

### Dependency injection (get_it)
`configureDependencies()` in `lib/core/di/injection.dart` runs once in `main()` before `runApp`.
Access anywhere via the global `sl<T>()`. Registration conventions:
- `registerSingleton` / `registerLazySingleton` — shared services and app-wide state
  (`ApiClient`, repositories, use cases, `ThemeCubit`).
- `registerFactory` — per-screen cubits that need a fresh instance (`RaffleSubmitCubit`,
  `StatisticsCubit`); obtained with `sl<T>()` and provided via `BlocProvider`.
- Some short-lived UI cubits (`RaffleSetupCubit`, participants/gifts) are **not** in get_it —
  they're instantiated directly in their `StatefulWidget` and closed in `dispose`. Follow the
  pattern of the nearest sibling screen when adding a new one.

### Networking
All HTTP goes through `core/network/ApiClient` (wraps `http.Client`, sets JSON +
`Accept-Language: tr` headers, throws `ServerException` / `NetworkException` from
`core/error/exceptions.dart`). URLs live in `core/network/api_endpoints.dart` — never hardcode
endpoints in datasources. `RaffleRequestModel.toJson` only includes the `gifts` key when gifts
are present (matches the existing API contract — don't send an empty `gifts` array).

### Navigation & theme
Single `MaterialApp` in `lib/app/app.dart`; screens navigate with `Navigator.push`/`MaterialPageRoute`
(no named routes). Startup is `SplashScreen` → `HomeScreen`. Light/dark/system theme is held by
`ThemeCubit` (the only `BlocProvider` at the root) and persisted to `SharedPreferences`.

## Conventions

- Lint rules in `analysis_options.yaml` are enforced: single quotes, explicit return types,
  `const` constructors, `prefer_final_locals`. Run `flutter analyze` before considering work done.
- Constants, strings, asset paths, and colors/typography are centralized under `core/constants/`
  and `core/theme/` — reference those rather than literals.
- Tests use `flutter_test` + `bloc_test`. Cubit tests live in `test/presentation/`; widget/smoke
  tests reset and re-run `configureDependencies()` with `SharedPreferences.setMockInitialValues`
  in `setUpAll` (see `test/app_smoke_test.dart`).
