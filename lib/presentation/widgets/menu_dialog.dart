import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/theme_cubit.dart';
import '../../core/utils/url_launcher_helper.dart';
import 'primary_button.dart';

/// Shows the home menu with navigation, external links and a theme toggle.
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
        const SnackBar(content: Text(AppStrings.genericError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: AppConstants.dialogInset,
      title: const Text(AppStrings.appName, textAlign: TextAlign.center),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          PrimaryButton(
            label: AppStrings.statistics,
            icon: Icons.bar_chart_rounded,
            onPressed: () {
              Navigator.of(context).pop();
              onStatistics();
            },
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: AppStrings.about,
            icon: Icons.info_outline_rounded,
            onPressed: () {
              Navigator.of(context).pop();
              onAbout();
            },
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: AppStrings.rateUs,
            icon: Icons.star_rounded,
            onPressed: () => _openUrl(context, AppConstants.playStoreUrl),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: AppStrings.website,
            icon: Icons.public_rounded,
            onPressed: () => _openUrl(context, AppConstants.websiteUrl),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: AppStrings.contribute,
            icon: Icons.code_rounded,
            onPressed: () => _openUrl(context, AppConstants.repoUrl),
          ),
          const SizedBox(height: 12),
          const _ThemeToggleButton(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.close),
        ),
      ],
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
          ThemeMode.system => (Icons.brightness_auto_rounded, 'Sistem'),
          ThemeMode.light => (Icons.light_mode_rounded, 'Açık'),
          ThemeMode.dark => (Icons.dark_mode_rounded, 'Koyu'),
        };
        return PrimaryButton(
          label: '${AppStrings.theme}: $label',
          icon: icon,
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () => context.read<ThemeCubit>().toggle(),
        );
      },
    );
  }
}
