import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/l10n/raffle_texts.dart';
import '../../../core/utils/share_helper.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../../domain/entities/draw_assignment.dart';
import '../../../domain/entities/raffle.dart';
import '../../../domain/services/share_code.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubit/raffle_result/raffle_result_cubit.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_list_tile_card.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/result_card.dart';

/// Shows a drawn raffle. New-year results stay hidden until each participant
/// reveals their own; gift raffle winners are listed openly. Results can be
/// shared one by one, and when Firebase is configured each participant can
/// get a personal online code instead.
class RaffleResultScreen extends StatelessWidget {
  const RaffleResultScreen({
    super.key,
    required this.raffle,
    this.celebrate = false,
  });

  final Raffle raffle;

  /// Plays confetti on open; used right after the draw.
  final bool celebrate;

  /// Replaces the raffle creation flow with the result, so going back returns
  /// to the home screen.
  static void openAfterDraw(BuildContext context, Raffle raffle) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => RaffleResultScreen(raffle: raffle, celebrate: true),
      ),
      (Route<dynamic> route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RaffleResultCubit>(
      create: (_) => sl<RaffleResultCubit>(param1: raffle),
      child: _RaffleResultView(celebrate: celebrate),
    );
  }
}

class _RaffleResultView extends StatefulWidget {
  const _RaffleResultView({required this.celebrate});

  final bool celebrate;

  @override
  State<_RaffleResultView> createState() => _RaffleResultViewState();
}

class _RaffleResultViewState extends State<_RaffleResultView> {
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  void initState() {
    super.initState();
    if (widget.celebrate) _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _publish(BuildContext context) async {
    final RaffleResultCubit cubit = context.read<RaffleResultCubit>();
    final bool confirmed = await showConfirmDialog(
      context,
      title: context.l10n.publishOnline,
      message: context.l10n.publishInfo,
      confirmLabel: context.l10n.publishOnline,
    );
    if (confirmed) await cubit.publish();
  }

  void _onPublishStatus(BuildContext context, RaffleResultState state) {
    if (state.publishStatus == PublishStatus.published) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.codesReady)),
      );
    } else if (state.publishStatus == PublishStatus.failure) {
      showWarningDialog(context, context.l10n.publishFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RaffleResultCubit, RaffleResultState>(
      listenWhen: (RaffleResultState previous, RaffleResultState current) =>
          previous.publishStatus != current.publishStatus,
      listener: _onPublishStatus,
      builder: (BuildContext context, RaffleResultState state) {
        final Raffle raffle = state.raffle;
        final bool canPublish =
            context.read<RaffleResultCubit>().canPublish && !raffle.isPublished;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(),
          body: AppBackground(
            child: Stack(
              children: <Widget>[
                SafeArea(
                  child: LoadingOverlay(
                    isLoading: state.isPublishing,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.pagePadding,
                            ),
                            children: <Widget>[
                              _Header(raffle: raffle),
                              const SizedBox(height: 16),
                              for (int i = 0;
                                  i < raffle.assignments.length;
                                  i++)
                                _AssignmentTile(
                                  raffle: raffle,
                                  index: i,
                                  revealed: state.revealed.contains(i),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.all(AppConstants.pagePadding),
                          child: Column(
                            children: <Widget>[
                              if (!raffle.type.isNewYear)
                                Builder(
                                  builder: (BuildContext context) =>
                                      PrimaryButton(
                                    label: context.l10n.shareResults,
                                    icon: Icons.share_rounded,
                                    onPressed: () => ShareHelper.shareText(
                                      context,
                                      allResultsMessage(context.l10n, raffle),
                                      subject: raffle.title,
                                    ),
                                  ),
                                ),
                              if (!raffle.type.isNewYear && canPublish)
                                const SizedBox(height: 12),
                              if (canPublish)
                                PrimaryButton(
                                  label: context.l10n.publishOnline,
                                  icon: Icons.cloud_upload_rounded,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  onPressed: () => _publish(context),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    blastDirection: pi / 2,
                    maxBlastForce: 5,
                    minBlastForce: 2,
                    emissionFrequency: 0.2,
                    numberOfParticles: 30,
                    gravity: 0.05,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.raffle});

  final Raffle raffle;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final String info = raffle.isPublished
        ? context.l10n.codesReady
        : raffle.type.isNewYear
            ? context.l10n.resultSecretInfo
            : context.l10n.resultGiftInfo;
    return GlassCard(
      child: Column(
        children: <Widget>[
          Text(
            raffle.title,
            textAlign: TextAlign.center,
            style: text.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            raffleSummary(context.l10n, raffle),
            textAlign: TextAlign.center,
            style: text.bodyMedium,
          ),
          if (raffle.note.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              raffle.note,
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
          const SizedBox(height: 12),
          Text(info, textAlign: TextAlign.center, style: text.titleMedium),
        ],
      ),
    );
  }
}

enum _ShareChannel { share, email }

class _AssignmentTile extends StatelessWidget {
  const _AssignmentTile({
    required this.raffle,
    required this.index,
    required this.revealed,
  });

  final Raffle raffle;
  final int index;
  final bool revealed;

  DrawAssignment get _assignment => raffle.assignments[index];

  Future<void> _reveal(BuildContext context) async {
    final RaffleResultCubit cubit = context.read<RaffleResultCubit>();
    final String name = _assignment.participant.name;
    final bool ready = await showConfirmDialog(
      context,
      title: context.l10n.revealTitle(name),
      message: context.l10n.revealBody(name),
      confirmLabel: context.l10n.reveal,
    );
    if (!ready || !context.mounted) return;
    cubit.markRevealed(index);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: AppConstants.dialogInset,
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: ResultCard(
              type: raffle.type,
              participantName: name,
              match: _assignment.match,
              note: raffle.note,
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.visibility_off_rounded),
            label: Text(context.l10n.hide),
          ),
        ],
      ),
    );
  }

  Future<void> _share(BuildContext context) async {
    final AppLocalizations l10n = context.l10n;
    final String message = participantMessage(l10n, raffle, _assignment);
    final String subject = l10n.emailSubject(raffle.title);
    final String? email = _assignment.participant.email;

    final _ShareChannel? channel = email == null || email.isEmpty
        ? _ShareChannel.share
        : await showModalBottomSheet<_ShareChannel>(
            context: context,
            builder: (BuildContext context) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.share_rounded),
                    title: Text(l10n.share),
                    onTap: () => Navigator.of(context).pop(_ShareChannel.share),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email_rounded),
                    title: Text(l10n.sendByEmail),
                    subtitle: Text(email),
                    onTap: () => Navigator.of(context).pop(_ShareChannel.email),
                  ),
                ],
              ),
            ),
          );
    if (channel == null || !context.mounted) return;

    switch (channel) {
      case _ShareChannel.share:
        await ShareHelper.shareText(context, message, subject: subject);
      case _ShareChannel.email:
        final bool opened = await UrlLauncherHelper.email(
          to: email!,
          subject: subject,
          body: message,
        );
        if (!opened && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.genericError)),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DrawAssignment assignment = _assignment;
    final String? code = assignment.code;
    final bool secret = raffle.type.isNewYear;

    final String status = secret
        ? (revealed ? context.l10n.seen : context.l10n.tapToReveal)
        : assignment.match ?? context.l10n.noPrizeShort;
    final IconData icon = secret
        ? (revealed ? Icons.check_circle_rounded : Icons.lock_rounded)
        : assignment.match == null
            ? Icons.remove_circle_outline_rounded
            : Icons.card_giftcard_rounded;

    return AppListTileCard(
      leading: icon,
      title: assignment.participant.name,
      subtitle: code == null
          ? status
          : '$status • ${context.l10n.codeLabel(ShareCode.format(code))}',
      onTap: secret ? () => _reveal(context) : null,
      trailing: Builder(
        builder: (BuildContext context) => IconButton(
          tooltip: context.l10n.share,
          icon: const Icon(Icons.share_rounded),
          onPressed: () => _share(context),
        ),
      ),
    );
  }
}
