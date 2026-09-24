import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/l10n/raffle_texts.dart';
import '../../../domain/entities/raffle.dart';
import '../../cubit/history/history_cubit.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_list_tile_card.dart';
import '../../widgets/glass_card.dart';
import '../raffle_result/raffle_result_screen.dart';

/// Raffles drawn on this device, newest first.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryCubit>(
      create: (_) => sl<HistoryCubit>()..load(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(),
        body: AppBackground(
          child: SafeArea(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (BuildContext context, HistoryState state) {
                return switch (state.status) {
                  HistoryStatus.loading =>
                    const Center(child: CircularProgressIndicator()),
                  HistoryStatus.error =>
                    _Message(text: context.l10n.genericError),
                  HistoryStatus.loaded when state.raffles.isEmpty =>
                    _Message(text: context.l10n.historyEmpty),
                  HistoryStatus.loaded => _HistoryList(raffles: state.raffles),
                };
              },
            ),
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
      title: raffle.title,
      message: message,
      confirmLabel: context.l10n.delete,
    );
    if (confirmed) await cubit.delete(raffle);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.pagePadding),
      children: <Widget>[
        Text(
          context.l10n.history,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        for (final Raffle raffle in raffles)
          AppListTileCard(
            leading: raffle.type.isNewYear
                ? Icons.celebration_rounded
                : Icons.card_giftcard_rounded,
            title: raffle.title,
            subtitle: raffleSummary(context.l10n, raffle),
            onTap: () => _open(context, raffle),
            onDelete: () => _delete(context, raffle),
          ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.pagePadding),
        child: GlassCard(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
