import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// A tinted list row used for participants, gifts, results and history, with
/// an optional tap target and either a custom [trailing] widget or a delete
/// action.
class AppListTileCard extends StatelessWidget {
  const AppListTileCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onDelete,
  });

  final String title;

  /// Hidden when null or empty.
  final String? subtitle;
  final IconData? leading;

  /// Replaces the delete button when set.
  final Widget? trailing;
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
          leading: leading == null ? null : Icon(leading, color: onContainer),
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: onContainer),
          ),
          subtitle: subtitle == null || subtitle!.isEmpty
              ? null
              : Text(
                  subtitle!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: onContainer.withValues(alpha: 0.85)),
                ),
          iconColor: onContainer,
          trailing: trailing ??
              (onDelete == null
                  ? null
                  : IconButton(
                      icon: Icon(Icons.delete_outline, color: onContainer),
                      onPressed: onDelete,
                    )),
        ),
      ),
    );
  }
}
