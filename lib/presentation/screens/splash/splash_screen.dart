import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../widgets/app_background.dart';
import '../home/home_screen.dart';

/// Branded splash shown for a fixed duration before the home screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppConstants.splashDuration, _goHome);
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(AppAssets.logo, width: 180),
              const SizedBox(height: 16),
              Text(
                context.l10n.appName,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
