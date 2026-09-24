import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/l10n/locale_cubit.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/section_header.dart';
import '../about/about_screen.dart';
import '../history/history_screen.dart';
import '../statistics/statistics_screen.dart';

/// Theme and language preferences, plus links to the secondary screens and
/// the project's external pages.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final bool ok = await UrlLauncherHelper.open(url);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.genericError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: context.l10n.settings,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.xl,
        ),
        children: <Widget>[
          SectionHeader(context.l10n.theme),
          const _ThemeSelector(),
          SectionHeader(context.l10n.language),
          const _LanguageSelector(),
          SectionHeader(context.l10n.more),
          _TileGroup(
            children: <Widget>[
              _NavigationTile(
                icon: Icons.history_rounded,
                label: context.l10n.history,
                onTap: () => _push(context, const HistoryScreen()),
              ),
              _NavigationTile(
                icon: Icons.insights_rounded,
                label: context.l10n.statistics,
                onTap: () => _push(context, const StatisticsScreen()),
              ),
              _NavigationTile(
                icon: Icons.info_outline_rounded,
                label: context.l10n.about,
                onTap: () => _push(context, const AboutScreen()),
              ),
            ],
          ),
          SectionHeader(context.l10n.support),
          _TileGroup(
            children: <Widget>[
              _NavigationTile(
                icon: Icons.star_outline_rounded,
                label: context.l10n.rateUs,
                external: true,
                onTap: () => _openUrl(context, AppConstants.playStoreUrl),
              ),
              _NavigationTile(
                icon: Icons.public_rounded,
                label: context.l10n.website,
                external: true,
                onTap: () => _openUrl(context, AppConstants.websiteUrl),
              ),
              _NavigationTile(
                icon: Icons.code_rounded,
                label: context.l10n.contribute,
                external: true,
                onTap: () => _openUrl(context, AppConstants.repoUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    final ThemeMode mode = context.watch<ThemeCubit>().state;
    return SegmentedButton<ThemeMode>(
      expandedInsets: EdgeInsets.zero,
      showSelectedIcon: false,
      selected: <ThemeMode>{mode},
      onSelectionChanged: (Set<ThemeMode> selection) =>
          context.read<ThemeCubit>().setMode(selection.single),
      segments: <ButtonSegment<ThemeMode>>[
        ButtonSegment<ThemeMode>(
          value: ThemeMode.system,
          icon: const Icon(Icons.brightness_auto_rounded),
          label: Text(context.l10n.themeSystem),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.light,
          icon: const Icon(Icons.light_mode_rounded),
          label: Text(context.l10n.themeLight),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.dark,
          icon: const Icon(Icons.dark_mode_rounded),
          label: Text(context.l10n.themeDark),
        ),
      ],
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    final String current = context.watch<LocaleCubit>().state.languageCode;
    return _TileGroup(
      children: <Widget>[
        for (final Locale locale in kSupportedLocales)
          ListTile(
            selected: locale.languageCode == current,
            title: Text(
              kLanguageNames[locale.languageCode] ?? locale.languageCode,
            ),
            trailing: locale.languageCode == current
                ? const Icon(Icons.check_rounded)
                : null,
            onTap: () => context.read<LocaleCubit>().setLocale(locale),
          ),
      ],
    );
  }
}

/// List tiles on one card, separated by inset dividers. The card clips the
/// ink, so the tiles themselves are square.
class _TileGroup extends StatelessWidget {
  const _TileGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTileTheme.merge(
        shape: const RoundedRectangleBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          children: <Widget>[
            for (int i = 0; i < children.length; i++) ...<Widget>[
              if (i > 0) const Divider(indent: AppSpacing.lg),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.external = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Opens a page outside the app.
  final bool external;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Icon(
        external ? Icons.open_in_new_rounded : Icons.chevron_right_rounded,
        size: 20,
        color: context.colors.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
