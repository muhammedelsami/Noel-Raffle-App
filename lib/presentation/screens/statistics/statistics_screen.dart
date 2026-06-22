import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection.dart';
import '../../../domain/entities/statistics.dart';
import '../../cubit/statistics/statistics_cubit.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo_header.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';

/// Shows aggregate raffle statistics fetched from the backend.
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
                return switch (state.status) {
                  StatisticsStatus.loading =>
                    const Center(child: CircularProgressIndicator()),
                  StatisticsStatus.error => _ErrorView(
                      message: state.error ?? AppStrings.genericError,
                      onRetry: () => context.read<StatisticsCubit>().load(),
                    ),
                  StatisticsStatus.loaded => _StatisticsContent(state.data!),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StatisticsContent extends StatelessWidget {
  const _StatisticsContent(this.stats);

  final Statistics stats;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.pagePadding),
      child: Column(
        children: <Widget>[
          const AppLogoHeader(),
          Image.asset(AppAssets.logo, height: 200),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              children: <Widget>[
                _StatRow(AppStrings.statTotalRaffle, stats.totalRaffleCount),
                _StatRow(
                    AppStrings.statNewYearRaffle, stats.newYearRaffleCount),
                _StatRow(AppStrings.statGiftRaffle, stats.giftRaffleCount),
                _StatRow(AppStrings.statGiftCount, stats.giftCount),
                _StatRow(
                    AppStrings.statParticipantCount, stats.participantCount),
              ],
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: style),
          Text('$value', style: style),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.pagePadding),
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              PrimaryButton(label: AppStrings.ok, onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}
