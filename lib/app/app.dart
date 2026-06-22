import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_strings.dart';
import '../core/di/injection.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_cubit.dart';
import '../presentation/screens/splash/splash_screen.dart';

/// Root widget: wires the single [MaterialApp], the light/dark themes and the
/// app-wide [ThemeCubit].
class NoelRaffleApp extends StatelessWidget {
  const NoelRaffleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>.value(
      value: sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (BuildContext context, ThemeMode mode) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: mode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
