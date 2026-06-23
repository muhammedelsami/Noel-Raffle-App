import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection.dart';
import '../core/l10n/l10n_extensions.dart';
import '../core/l10n/locale_cubit.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_cubit.dart';
import '../l10n/app_localizations.dart';
import '../presentation/screens/splash/splash_screen.dart';

/// Root widget: wires the single [MaterialApp], the light/dark themes, the
/// app-wide [ThemeCubit] and [LocaleCubit] (TR / EN / AR; Arabic renders RTL).
class NoelRaffleApp extends StatelessWidget {
  const NoelRaffleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<ThemeCubit>.value(value: sl<ThemeCubit>()),
        BlocProvider<LocaleCubit>.value(value: sl<LocaleCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (BuildContext context, Locale locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (BuildContext context, ThemeMode mode) {
              return MaterialApp(
                onGenerateTitle: (BuildContext context) => context.l10n.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: mode,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
