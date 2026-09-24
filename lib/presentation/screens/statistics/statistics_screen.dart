import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/theme_context.dart';
import '../../../domain/entities/statistics.dart';
import '../../cubit/statistics/statistics_cubit.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/icon_badge.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/section_header.dart';

/// Shows this device's raffle totals and, when Firebase is configured, the
/// totals across all users.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (_) => sl<StatisticsCubit>()..load(),
      child: Builder(
        builder: (BuildContext context) => PageScaffold(
          title: context.l10n.statistics,
          body: BlocBuilder<StatisticsCubit, StatisticsState>(
            builder: (BuildContext context, StatisticsState state) {
              final Statistics? local = state.local;
              if (local == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  0,
                  AppSpacing.page,
                  AppSpacing.xl,
                ),
                children: <Widget>[
                  SectionHeader(context.l10n.statsThisDevice),
                  _StatisticsGrid(local),
                  if (state.globalStatus !=
                      GlobalStatisticsStatus.unavailable) ...<Widget>[
                    SectionHeader(context.l10n.statsAllUsers),
                    _GlobalStatistics(state: state),
                  ],
                ],
              );
            },
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
      GlobalStatisticsStatus.loaded => _StatisticsGrid(state.global!),
      GlobalStatisticsStatus.error => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InfoBanner(
              tone: BannerTone.error,
              message: context.l10n.globalStatsError,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton.outlined(
              label: context.l10n.retry,
              icon: Icons.refresh_rounded,
              onPressed: () => context.read<StatisticsCubit>().load(),
            ),
          ],
        ),
      _ => const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        ),
    };
  }
}

/// The total as a highlighted card, then the breakdown two by two.
class _StatisticsGrid extends StatelessWidget {
  const _StatisticsGrid(this.stats);

  final Statistics stats;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _StatTile(
          icon: Icons.confirmation_number_outlined,
          label: context.l10n.statTotalRaffle,
          value: stats.totalRaffleCount,
          background: colors.primaryContainer,
          foreground: colors.onPrimaryContainer,
          large: true,
        ),
        const SizedBox(height: AppSpacing.md),
        _TilePair(
          _StatTile(
            icon: Icons.ac_unit_rounded,
            label: context.l10n.statNewYearRaffle,
            value: stats.newYearRaffleCount,
          ),
          _StatTile(
            icon: Icons.card_giftcard_rounded,
            label: context.l10n.statGiftRaffle,
            value: stats.giftRaffleCount,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _TilePair(
          _StatTile(
            icon: Icons.group_rounded,
            label: context.l10n.statParticipantCount,
            value: stats.participantCount,
          ),
          _StatTile(
            icon: Icons.inventory_2_outlined,
            label: context.l10n.statGiftCount,
            value: stats.giftCount,
          ),
        ),
      ],
    );
  }
}

/// Two tiles side by side with equal heights.
class _TilePair extends StatelessWidget {
  const _TilePair(this.start, this.end);

  final Widget start;
  final Widget end;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: start),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: end),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.background,
    this.foreground,
    this.large = false,
  });

  final IconData icon;
  final String label;
  final int value;

  /// Tints the whole tile; defaults to a plain card.
  final Color? background;
  final Color? foreground;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    final TextTheme text = context.textTheme;
    final Color foreground = this.foreground ?? colors.onSurface;
    final String formatted =
        NumberFormat.decimalPattern(context.l10n.localeName).format(value);
    return MergeSemantics(
      child: AppCard(
        color: background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconBadge(
              icon: icon,
              size: 36,
              background:
                  background == null ? colors.surfaceContainerHigh : foreground,
              foreground: background ?? colors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              formatted,
              style: (large ? text.displaySmall : text.headlineMedium)
                  ?.copyWith(color: foreground),
            ),
            Text(
              label,
              style: text.bodyMedium?.copyWith(
                color:
                    background == null ? colors.onSurfaceVariant : foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
