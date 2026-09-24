import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../domain/entities/raffle_type.dart';
import '../../../domain/usecases/lookup_result.dart';
import '../../widgets/app_background.dart';
import '../../widgets/menu_dialog.dart';
import '../../widgets/primary_button.dart';
import '../about/about_screen.dart';
import '../history/history_screen.dart';
import '../raffle_setup/raffle_setup_screen.dart';
import '../result_lookup/result_lookup_screen.dart';
import '../statistics/statistics_screen.dart';

/// Landing screen where the user picks a raffle type, looks up their own
/// result (online only) or opens the menu.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final bool canLookup = sl<LookupResult>().isAvailable;
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
                          onHistory: () =>
                              _push(context, const HistoryScreen()),
                          onStatistics: () =>
                              _push(context, const StatisticsScreen()),
                          onAbout: () => _push(context, const AboutScreen()),
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
                      Image.asset(AppAssets.giftRaffle,
                          width: 180, height: 180),
                      const SizedBox(height: 16),
                      Text(context.l10n.homeTitle, style: text.displayMedium),
                      const SizedBox(height: 8),
                      Text(context.l10n.homeSubtitle, style: text.titleMedium),
                      const SizedBox(height: 40),
                      PrimaryButton(
                        label: context.l10n.newYearRaffle,
                        icon: Icons.celebration_rounded,
                        onPressed: () => _push(
                          context,
                          const RaffleSetupScreen(type: RaffleType.newYear),
                        ),
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: context.l10n.giftRaffle,
                        icon: Icons.card_giftcard_rounded,
                        onPressed: () => _push(
                          context,
                          const RaffleSetupScreen(type: RaffleType.gift),
                        ),
                      ),
                      if (canLookup) ...<Widget>[
                        const SizedBox(height: 16),
                        PrimaryButton(
                          label: context.l10n.viewMyResult,
                          icon: Icons.vpn_key_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () =>
                              _push(context, const ResultLookupScreen()),
                        ),
                      ],
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
