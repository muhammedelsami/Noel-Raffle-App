import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../domain/entities/statistics.dart';
import '../../cubit/statistics/statistics_cubit.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo_header.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';

/// Shows this device's raffle totals and, when Firebase is configured, the
/// totals across all users.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (_) => sl<StatisticsCubit>()..load(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(),
        body: AppBackground(
          child: SafeArea(
            child: BlocBuilder<StatisticsCubit, StatisticsState>(
              builder: (BuildContext context, StatisticsState state) {
                final Statistics? local = state.local;
                if (local == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.pagePadding),
                  child: Column(
                    children: <Widget>[
                      const AppLogoHeader(),
                      Image.asset(AppAssets.logo, height: 160),
                      const SizedBox(height: 16),
                      _StatisticsCard(
                        title: context.l10n.statsThisDevice,
                        child: _StatisticsRows(local),
                      ),
                      if (state.globalStatus !=
                          GlobalStatisticsStatus.unavailable) ...<Widget>[
                        const SizedBox(height: 16),
                        _StatisticsCard(
                          title: context.l10n.statsAllUsers,
                          child: _GlobalStatistics(state: state),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _GlobalStatistics extends StatelessWidget {
  const _GlobalStatistics({required this.state});

  final StatisticsState state;

  @override
  Widget build(BuildContext context) {
    return switch (state.globalStatus) {
      GlobalStatisticsStatus.loaded => _StatisticsRows(state.global!),
      GlobalStatisticsStatus.error => Column(
          children: <Widget>[
            Text(
              context.l10n.globalStatsError,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: context.l10n.retry,
              icon: Icons.refresh_rounded,
              onPressed: () => context.read<StatisticsCubit>().load(),
            ),
          ],
        ),
      _ => const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
    };
  }
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

class _StatisticsRows extends StatelessWidget {
  const _StatisticsRows(this.stats);

  final Statistics stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _StatRow(context.l10n.statTotalRaffle, stats.totalRaffleCount),
        _StatRow(context.l10n.statNewYearRaffle, stats.newYearRaffleCount),
        _StatRow(context.l10n.statGiftRaffle, stats.giftRaffleCount),
        _StatRow(context.l10n.statGiftCount, stats.giftCount),
        _StatRow(context.l10n.statParticipantCount, stats.participantCount),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow(this.label, this.value);

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).textTheme.titleLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(child: Text(label, style: style)),
          Text('$value', style: style),
        ],
      ),
    );
  }
}
