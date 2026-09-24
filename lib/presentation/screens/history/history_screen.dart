import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/l10n/raffle_texts.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/raffle_type_style.dart';
import '../../../core/theme/theme_context.dart';
import '../../../domain/entities/raffle.dart';
import '../../cubit/history/history_cubit.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_list_tile.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/icon_badge.dart';
import '../../widgets/page_scaffold.dart';
import '../raffle_result/raffle_result_screen.dart';

/// Raffles drawn on this device, newest first.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryCubit>(
      create: (_) => sl<HistoryCubit>()..load(),
      child: Builder(
        builder: (BuildContext context) => PageScaffold(
          title: context.l10n.history,
          body: BlocBuilder<HistoryCubit, HistoryState>(
            builder: (BuildContext context, HistoryState state) {
              return switch (state.status) {
                HistoryStatus.loading =>
                  const Center(child: CircularProgressIndicator()),
                HistoryStatus.error => EmptyState(
                    icon: Icons.error_outline_rounded,
                    title: context.l10n.genericError,
                    action: AppButton.outlined(
                      label: context.l10n.retry,
                      icon: Icons.refresh_rounded,
                      expand: false,
                      onPressed: () => context.read<HistoryCubit>().load(),
                    ),
                  ),
                HistoryStatus.loaded when state.raffles.isEmpty => EmptyState(
                    icon: Icons.history_rounded,
                    title: context.l10n.historyEmpty,
                  ),
                HistoryStatus.loaded => _HistoryList(raffles: state.raffles),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.raffles});

  final List<Raffle> raffles;

  Future<void> _open(BuildContext context, Raffle raffle) async {
    final HistoryCubit cubit = context.read<HistoryCubit>();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RaffleResultScreen(raffle: raffle),
      ),
    );
    // Publishing on the result screen updates the saved raffle.
    await cubit.load();
  }

  Future<void> _delete(BuildContext context, Raffle raffle) async {
    final HistoryCubit cubit = context.read<HistoryCubit>();
    final String message = raffle.isPublished
        ? '${context.l10n.deleteRaffleConfirm}\n'
            '${context.l10n.deleteRaffleCodesNote}'
        : context.l10n.deleteRaffleConfirm;
    final bool confirmed = await showConfirmDialog(
      context,
      icon: Icons.delete_outline_rounded,
      title: raffle.title,
      message: message,
      confirmLabel: context.l10n.delete,
      destructive: true,
    );
    if (confirmed) await cubit.delete(raffle);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.xl,
      ),
      itemCount: raffles.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (BuildContext context, int index) {
        final Raffle raffle = raffles[index];
        final AccentColors accent = raffle.type.accentColors(colors);
        return AppListTile(
          key: ValueKey<String>(raffle.id),
          leading: IconBadge(
            icon: raffle.type.icon,
            background: accent.container,
            foreground: accent.onContainer,
          ),
          title: raffle.title,
          subtitle: Text(raffleSummary(context.l10n, raffle)),
          onTap: () => _open(context, raffle),
          onDelete: () => _delete(context, raffle),
        );
      },
    );
  }
}
