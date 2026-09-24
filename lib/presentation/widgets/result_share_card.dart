import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/share_helper.dart';
import '../../domain/entities/draw_assignment.dart';
import '../../domain/entities/raffle.dart';
import '../../domain/services/share_code.dart';
import 'brand_mark.dart';
import 'note_line.dart';
import 'result_card.dart';

/// Previews [assignment]'s result as an image card and shares it as a PNG.
Future<void> showResultCardPreview(
  BuildContext context, {
  required Raffle raffle,
  required DrawAssignment assignment,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _CardPreview(raffle: raffle, assignment: assignment),
  );
}

class _CardPreview extends StatefulWidget {
  const _CardPreview({required this.raffle, required this.assignment});

  final Raffle raffle;
  final DrawAssignment assignment;

  @override
  State<_CardPreview> createState() => _CardPreviewState();
}

class _CardPreviewState extends State<_CardPreview> {
  final GlobalKey _card = GlobalKey();
  bool _sharing = false;

  Future<void> _share(BuildContext buttonContext) async {
    setState(() => _sharing = true);
    try {
      final RenderRepaintBoundary boundary =
          _card.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final ByteData? png =
          await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (png == null || !buttonContext.mounted) return;
      await ShareHelper.shareImage(
        buttonContext,
        png.buffer.asUint8List(),
        fileName: 'noel-raffle.png',
        subject: widget.raffle.title,
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.resultCard),
      scrollable: true,
      content: FittedBox(
        child: RepaintBoundary(
          key: _card,
          child: ResultShareCard(
            raffle: widget.raffle,
            assignment: widget.assignment,
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        Builder(
          builder: (BuildContext buttonContext) => FilledButton.icon(
            onPressed: _sharing ? null : () => _share(buttonContext),
            icon: const Icon(Icons.share_rounded),
            label: Text(context.l10n.share),
          ),
        ),
      ],
    );
  }
}

/// A participant's result laid out as a card to send as an image. Always
/// drawn in the light theme, so every shared card looks the same. Once the
/// raffle is published it shows the personal code instead of the result.
class ResultShareCard extends StatelessWidget {
  const ResultShareCard({
    super.key,
    required this.raffle,
    required this.assignment,
  });

  static const double width = 340;

  final Raffle raffle;
  final DrawAssignment assignment;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light,
      child: Builder(
        builder: (BuildContext context) {
          final String? code = assignment.code;
          return Material(
            color: context.colors.surfaceContainerLowest,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.extraLarge,
            ),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Header(title: raffle.title),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: code == null
                        ? ResultCard(
                            type: raffle.type,
                            participantName: assignment.participant.name,
                            match: assignment.match,
                            matchWish: raffle.type.isNewYear
                                ? raffle.wishOf(assignment.match)
                                : null,
                            note: raffle.note,
                          )
                        : _CodeBody(
                            name: assignment.participant.name,
                            code: code,
                            note: raffle.note,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Text(
                      context.l10n.drawnWith,
                      textAlign: TextAlign.center,
                      style: context.textTheme.labelSmall
                          ?.copyWith(color: context.colors.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final Color onHero = context.brand.onHero;
    return DecoratedBox(
      decoration: BoxDecoration(gradient: context.brand.heroGradient),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.page),
        child: Row(
          children: <Widget>[
            const BrandMark(size: 40, elevated: true),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.appName,
                    style:
                        context.textTheme.titleMedium?.copyWith(color: onHero),
                  ),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: onHero.withValues(alpha: 0.9)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A published result: only the code, so whoever sends the card cannot see
/// the match.
class _CodeBody extends StatelessWidget {
  const _CodeBody({required this.name, required this.code, required this.note});

  final String name;
  final String code;
  final String note;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    final TextTheme text = context.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          context.l10n.greeting(name),
          textAlign: TextAlign.center,
          style: text.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.lg),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.tertiaryContainer,
            borderRadius: AppRadius.large,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: <Widget>[
                Text(
                  context.l10n.yourCode,
                  style: text.labelLarge
                      ?.copyWith(color: colors.onTertiaryContainer),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  ShareCode.format(code),
                  textDirection: TextDirection.ltr,
                  style: text.headlineLarge?.copyWith(
                    color: colors.onTertiaryContainer,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          context.l10n.cardCodeHint,
          textAlign: TextAlign.center,
          style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
        if (note.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          NoteLine(note),
        ],
      ],
    );
  }
}
