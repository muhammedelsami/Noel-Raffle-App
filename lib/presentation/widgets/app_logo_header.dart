import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/l10n/l10n_extensions.dart';

/// Small logo + app name row used on secondary screens.
class AppLogoHeader extends StatelessWidget {
  const AppLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Image.asset(AppAssets.logoSmall, height: 64, width: 64),
          const SizedBox(width: 12),
          Text(
            context.l10n.appName,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
