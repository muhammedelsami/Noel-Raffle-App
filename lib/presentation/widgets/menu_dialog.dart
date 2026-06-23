import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/l10n/locale_cubit.dart';
import '../../core/theme/theme_cubit.dart';
import '../../core/utils/url_launcher_helper.dart';
import 'primary_button.dart';

/// Shows the home menu with navigation, external links, a theme toggle and a
/// language picker.
Future<void> showAppMenu(
  BuildContext context, {
  required VoidCallback onStatistics,
  required VoidCallback onAbout,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _MenuDialog(onStatistics: onStatistics, onAbout: onAbout),
  );
}

class _MenuDialog extends StatelessWidget {
  const _MenuDialog({required this.onStatistics, required this.onAbout});

  final VoidCallback onStatistics;
  final VoidCallback onAbout;

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
    return AlertDialog(
      insetPadding: AppConstants.dialogInset,
      title: Text(context.l10n.appName, textAlign: TextAlign.center),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PrimaryButton(
              label: context.l10n.statistics,
              icon: Icons.bar_chart_rounded,
              onPressed: () {
                Navigator.of(context).pop();
                onStatistics();
              },
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: context.l10n.about,
              icon: Icons.info_outline_rounded,
              onPressed: () {
                Navigator.of(context).pop();
                onAbout();
              },
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: context.l10n.rateUs,
              icon: Icons.star_rounded,
              onPressed: () => _openUrl(context, AppConstants.playStoreUrl),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: context.l10n.website,
              icon: Icons.public_rounded,
              onPressed: () => _openUrl(context, AppConstants.websiteUrl),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: context.l10n.contribute,
              icon: Icons.code_rounded,
              onPressed: () => _openUrl(context, AppConstants.repoUrl),
            ),
            const SizedBox(height: 12),
            const _LanguageButton(),
            const SizedBox(height: 12),
            const _ThemeToggleButton(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.close),
        ),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton();

  Future<void> _pick(BuildContext context) async {
    final LocaleCubit cubit = context.read<LocaleCubit>();
    final Locale? choice = await showDialog<Locale>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text(context.l10n.language, textAlign: TextAlign.center),
        children: kSupportedLocales
            .map(
              (Locale locale) => SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(locale),
                child: Text(
                  kLanguageNames[locale.languageCode] ?? locale.languageCode,
                  textAlign: TextAlign.center,
                ),
              ),
            )
            .toList(),
      ),
    );
    if (choice != null) await cubit.setLocale(choice);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (BuildContext context, Locale locale) {
        final String name =
            kLanguageNames[locale.languageCode] ?? locale.languageCode;
        return PrimaryButton(
          label: '${context.l10n.language}: $name',
          icon: Icons.translate_rounded,
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () => _pick(context),
        );
      },
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (BuildContext context, ThemeMode mode) {
        final (IconData icon, String label) = switch (mode) {
          ThemeMode.system => (
              Icons.brightness_auto_rounded,
              context.l10n.themeSystem
            ),
          ThemeMode.light => (Icons.light_mode_rounded, context.l10n.themeLight),
          ThemeMode.dark => (Icons.dark_mode_rounded, context.l10n.themeDark),
        };
        return PrimaryButton(
          label: '${context.l10n.theme}: $label',
          icon: icon,
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () => context.read<ThemeCubit>().toggle(),
        );
      },
    );
  }
}
