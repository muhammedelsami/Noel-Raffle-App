import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/l10n/raffle_texts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/raffle_type_style.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/share_helper.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../../domain/entities/draw_assignment.dart';
import '../../../domain/entities/raffle.dart';
import '../../../domain/services/share_code.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubit/raffle_result/raffle_result_cubit.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_list_tile.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/initials_avatar.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/quote_note.dart';
import '../../widgets/result_card.dart';
import '../../widgets/status_pill.dart';

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

class _RaffleResultView extends StatelessWidget {
  const _RaffleResultView({required this.celebrate});

  final bool celebrate;

  Future<void> _publish(BuildContext context) async {
    final RaffleResultCubit cubit = context.read<RaffleResultCubit>();
    final bool confirmed = await showConfirmDialog(
      context,
      icon: Icons.cloud_upload_outlined,
      title: context.l10n.publishOnline,
      message: context.l10n.publishInfo,
      confirmLabel: context.l10n.publishOnline,
    );
    if (confirmed) await cubit.publish();
  }

  String _infoMessage(AppLocalizations l10n, Raffle raffle) {
    if (raffle.isPublished) return l10n.codesReady;
    return raffle.type.isNewYear ? l10n.resultSecretInfo : l10n.resultGiftInfo;
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
        final bool secret = raffle.type.isNewYear;
        final bool canPublish =
            context.read<RaffleResultCubit>().canPublish && !raffle.isPublished;
        return LoadingOverlay(
          isLoading: state.isPublishing,
          child: PageScaffold(
            body: Stack(
              children: <Widget>[
                CustomScrollView(
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.page,
                        AppSpacing.sm,
                        AppSpacing.page,
                        AppSpacing.lg,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _Header(raffle: raffle),
                            const SizedBox(height: AppSpacing.md),
                            InfoBanner(
                              tone: raffle.isPublished
                                  ? BannerTone.success
                                  : BannerTone.info,
                              message: _infoMessage(context.l10n, raffle),
                            ),
                            if (secret) ...<Widget>[
                              const SizedBox(height: AppSpacing.xl),
                              _RevealProgress(
                                seen: state.revealed.length,
                                total: raffle.assignments.length,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.page,
                        0,
                        AppSpacing.page,
                        AppSpacing.xl,
                      ),
                      sliver: SliverList.separated(
                        itemCount: raffle.assignments.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (BuildContext context, int index) =>
                            _AssignmentTile(
                          raffle: raffle,
                          index: index,
                          revealed: state.revealed.contains(index),
                        ),
                      ),
                    ),
                  ],
                ),
                if (celebrate) const _Confetti(),
              ],
            ),
            bottomBar: secret && !canPublish
                ? null
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (!secret)
                        Builder(
                          // Its own context anchors the iPad share popover.
                          builder: (BuildContext context) => AppButton(
                            label: context.l10n.shareResults,
                            icon: Icons.share_rounded,
                            onPressed: () => ShareHelper.shareText(
                              context,
                              allResultsMessage(context.l10n, raffle),
                              subject: raffle.title,
                            ),
                          ),
                        ),
                      if (!secret && canPublish)
                        const SizedBox(height: AppSpacing.md),
                      if (canPublish)
                        AppButton.tonal(
                          label: context.l10n.publishOnline,
                          icon: Icons.cloud_upload_outlined,
                          onPressed: () => _publish(context),
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

/// A one-off confetti burst from the top edge, isolated in its own layer so
/// the particles never repaint the list.
class _Confetti extends StatefulWidget {
  const _Confetti();

  @override
  State<_Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<_Confetti> {
  final ConfettiController _controller =
      ConfettiController(duration: const Duration(seconds: 2))..play();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    return IgnorePointer(
      child: RepaintBoundary(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            blastDirection: pi / 2,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.2,
            numberOfParticles: 24,
            gravity: 0.08,
            colors: <Color>[
              colors.primary,
              colors.secondary,
              AppColors.gold,
              colors.primaryContainer,
              colors.secondaryContainer,
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.raffle});

  final Raffle raffle;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = context.textTheme;
    final ColorScheme colors = context.colors;
    final AccentColors accent = raffle.type.accentColors(colors);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StatusPill(
            label: raffleTypeLabel(context.l10n, raffle.type),
            icon: raffle.type.icon,
            background: accent.container,
            foreground: accent.onContainer,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(raffle.title, style: text.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            raffleSummary(context.l10n, raffle),
            style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
          if (raffle.note.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            QuoteNote(raffle.note),
          ],
        ],
      ),
    );
  }
}

/// How many participants already looked at their secret result.
class _RevealProgress extends StatelessWidget {
  const _RevealProgress({required this.seen, required this.total});

  final int seen;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          context.l10n.revealProgress(seen, total),
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(end: total == 0 ? 0 : seen / total),
          duration: AppMotion.medium,
          curve: AppMotion.emphasized,
          builder: (_, double value, __) => LinearProgressIndicator(
            value: value,
            minHeight: 6,
            color: context.colors.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(3)),
          ),
        ),
      ],
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
      icon: Icons.visibility_outlined,
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
        scrollable: true,
        content: SizedBox(
          width: double.maxFinite,
          child: ResultCard(
            type: raffle.type,
            participantName: name,
            match: _assignment.match,
            note: raffle.note,
          ),
        ),
        actions: <Widget>[
          AppButton.tonal(
            label: context.l10n.hide,
            icon: Icons.visibility_off_outlined,
            onPressed: () => Navigator.of(context).pop(),
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
                    leading: const Icon(Icons.mail_outline_rounded),
                    title: Text(l10n.sendByEmail),
                    subtitle: Text(email),
                    onTap: () => Navigator.of(context).pop(_ShareChannel.email),
                  ),
                  const SizedBox(height: AppSpacing.sm),
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

    return AppListTile(
      leading: InitialsAvatar(assignment.participant.name),
      title: assignment.participant.name,
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xs),
        child: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            _StatusBadge(
              assignment: assignment,
              secret: secret,
              revealed: revealed,
            ),
            if (code != null)
              Text(context.l10n.codeLabel(ShareCode.format(code))),
          ],
        ),
      ),
      onTap: secret ? () => _reveal(context) : null,
      trailing: Builder(
        builder: (BuildContext context) => IconButton(
          tooltip: context.l10n.share,
          icon: const Icon(Icons.ios_share_rounded),
          onPressed: () => _share(context),
        ),
      ),
    );
  }
}

/// Secret raffle: whether the result was seen. Gift raffle: the prize won.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.assignment,
    required this.secret,
    required this.revealed,
  });

  final DrawAssignment assignment;
  final bool secret;
  final bool revealed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    final String? match = assignment.match;
    if (secret) {
      return revealed
          ? StatusPill(
              label: context.l10n.seen,
              icon: Icons.check_circle_rounded,
              background: colors.secondaryContainer,
              foreground: colors.onSecondaryContainer,
            )
          : StatusPill(
              label: context.l10n.tapToReveal,
              icon: Icons.lock_outline_rounded,
            );
    }
    return match == null
        ? StatusPill(
            label: context.l10n.noPrizeShort,
            icon: Icons.remove_circle_outline_rounded,
          )
        : StatusPill(
            label: match,
            icon: Icons.card_giftcard_rounded,
            background: colors.tertiaryContainer,
            foreground: colors.onTertiaryContainer,
          );
  }
}
