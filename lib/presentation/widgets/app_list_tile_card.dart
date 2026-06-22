import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// A tinted list row used for participants and gifts, with an edit tap target
/// and a delete action.
class AppListTileCard extends StatelessWidget {
  const AppListTileCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.onDelete,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color onContainer = scheme.onPrimaryContainer;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: onContainer),
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: onContainer.withValues(alpha: 0.85)),
          ),
          trailing: onDelete == null
              ? null
              : IconButton(
                  icon: Icon(Icons.delete_outline, color: onContainer),
                  onPressed: onDelete,
                ),
        ),
      ),
    );
  }
}
