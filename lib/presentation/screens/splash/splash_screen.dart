import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_context.dart';
import '../../widgets/brand_mark.dart';
import '../home/home_screen.dart';

/// Branded splash: the mark fades and scales in while the illustrations are
/// precached, then the home screen fades in.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: AppMotion.slow,
  )..forward();
  late final Animation<double> _fade =
      CurvedAnimation(parent: _intro, curve: AppMotion.emphasized);
  late final Animation<double> _scale =
      Tween<double>(begin: 0.85, end: 1).animate(_fade);

  Timer? _timer;
  bool _precached = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppConstants.splashDuration, _goHome);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;
    for (final String asset in AppAssets.illustrations) {
      precacheImage(AssetImage(asset), context);
    }
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: AppMotion.slow,
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder:
            (_, Animation<double> animation, __, Widget child) =>
                FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color onHero = context.brand.onHero;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.overlayStyle(darkBackground: true),
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: context.brand.heroGradient),
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const BrandMark(size: 112, elevated: true),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      context.l10n.appName,
                      style: context.textTheme.headlineLarge
                          ?.copyWith(color: onHero),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
