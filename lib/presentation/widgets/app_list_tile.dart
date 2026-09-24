import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';

/// A list row on a card, used for participants, gifts, results and history.
/// Shows [trailing], or a delete button when only [onDelete] is set.
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onDelete,
  });

  final String title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: leading,
        title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: subtitle,
        trailing: trailing ??
            (onDelete == null
                ? null
                : IconButton(
                    tooltip: context.l10n.delete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: onDelete,
                  )),
      ),
    );
  }
}
