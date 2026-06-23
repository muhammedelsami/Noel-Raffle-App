import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../domain/entities/raffle_type.dart';
import '../../widgets/app_background.dart';
import '../../widgets/menu_dialog.dart';
import '../../widgets/primary_button.dart';
import '../about/about_screen.dart';
import '../raffle_setup/raffle_setup_screen.dart';
import '../statistics/statistics_screen.dart';

/// Landing screen where the user picks a raffle type or opens the menu.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openSetup(BuildContext context, RaffleType type) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => RaffleSetupScreen(type: type)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(AppAssets.logoSmall, height: 56),
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.menu_rounded),
                        onPressed: () => showAppMenu(
                          context,
                          onStatistics: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const StatisticsScreen(),
                            ),
                          ),
                          onAbout: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const AboutScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(AppAssets.giftRaffle, width: 180, height: 180),
                      const SizedBox(height: 16),
                      Text(context.l10n.homeTitle, style: text.displayMedium),
                      const SizedBox(height: 8),
                      Text(context.l10n.homeSubtitle,
                          style: text.titleMedium),
                      const SizedBox(height: 40),
                      PrimaryButton(
                        label: context.l10n.newYearRaffle,
                        icon: Icons.celebration_rounded,
                        onPressed: () =>
                            _openSetup(context, RaffleType.newYear),
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: context.l10n.giftRaffle,
                        icon: Icons.card_giftcard_rounded,
                        onPressed: () => _openSetup(context, RaffleType.gift),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
