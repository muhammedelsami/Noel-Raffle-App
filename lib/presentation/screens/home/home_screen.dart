import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/l10n/raffle_texts.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/raffle_type_style.dart';
import '../../../core/theme/theme_context.dart';
import '../../../domain/entities/raffle_type.dart';
import '../../../domain/usecases/lookup_result.dart';
import '../../widgets/app_card.dart';
import '../../widgets/brand_mark.dart';
import '../../widgets/icon_badge.dart';
import '../../widgets/illustration.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/section_header.dart';
import '../history/history_screen.dart';
import '../raffle_setup/raffle_setup_screen.dart';
import '../result_lookup/result_lookup_screen.dart';
import '../settings/settings_screen.dart';
import '../statistics/statistics_screen.dart';

/// Landing screen: pick a raffle type, look up your own result (online only)
/// or jump to the history, statistics and settings.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final bool canLookup = sl<LookupResult>().isAvailable;
    final TextTheme text = context.textTheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.page,
        title: const BrandLogo(markSize: 32),
        actions: <Widget>[
          IconButton(
            tooltip: context.l10n.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _push(context, const SettingsScreen()),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ContentWidth(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.sm,
              AppSpacing.page,
              AppSpacing.xl,
            ),
            children: <Widget>[
              Semantics(
                header: true,
                child: Text(context.l10n.homeTitle, style: text.headlineMedium),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.homeSubtitle,
                style: text.bodyLarge
                    ?.copyWith(color: context.colors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xl),
              for (final RaffleType type in RaffleType.values) ...<Widget>[
                _RaffleTypeCard(
                  type: type,
                  onTap: () => _push(context, RaffleSetupScreen(type: type)),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (canLookup)
                _ActionRow(
                  icon: Icons.key_rounded,
                  title: context.l10n.viewMyResult,
                  subtitle: context.l10n.lookupDescription,
                  onTap: () => _push(context, const ResultLookupScreen()),
                ),
              SectionHeader(context.l10n.quickAccess),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.history_rounded,
                        label: context.l10n.history,
                        onTap: () => _push(context, const HistoryScreen()),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.insights_rounded,
                        label: context.l10n.statistics,
                        onTap: () => _push(context, const StatisticsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A large tinted card that starts a raffle of [type].
class _RaffleTypeCard extends StatelessWidget {
  const _RaffleTypeCard({required this.type, required this.onTap});

  final RaffleType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AccentColors accent = type.accentColors(context.colors);
    final TextTheme text = context.textTheme;
    final String description = switch (type) {
      RaffleType.newYear => context.l10n.newYearRaffleDescription,
      RaffleType.gift => context.l10n.giftRaffleDescription,
    };
    return AppCard(
      color: accent.container,
      onTap: onTap,
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.page,
        AppSpacing.page,
        AppSpacing.md,
        AppSpacing.page,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  raffleTypeLabel(context.l10n, type),
                  style: text.titleLarge?.copyWith(color: accent.onContainer),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: text.bodyMedium?.copyWith(color: accent.onContainer),
                ),
                const SizedBox(height: AppSpacing.md),
                ExcludeSemantics(
                  child: IconBadge(
                    icon: Icons.arrow_forward_rounded,
                    size: 36,
                    circle: true,
                    background: accent.accent,
                    foreground: accent.container,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Illustration(type.illustration, size: 112),
        ],
      ),
    );
  }
}

/// A full-width card row with an icon, a title, a hint and a chevron.
class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          IconBadge(
            icon: icon,
            background: colors.tertiaryContainer,
            foreground: colors.onTertiaryContainer,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: context.textTheme.titleMedium),
                Text(
                  subtitle,
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }
}

/// A compact shortcut card with an icon above its label.
class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconBadge(
            icon: icon,
            background: colors.surfaceContainerHigh,
            foreground: colors.onSurface,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(label, style: context.textTheme.titleSmall),
        ],
      ),
    );
  }
}
