import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/theme_context.dart';
import 'brand_mark.dart';

/// Plays a short animation that shuffles [names] before the results appear,
/// and completes when it is done. It only ever shows single names, never who
/// drew whom. Skipped when the platform asks for reduced motion.
Future<void> showDrawAnimation(
  BuildContext context, {
  required List<String> names,
}) {
  if (names.isEmpty || MediaQuery.disableAnimationsOf(context)) {
    return Future<void>.value();
  }
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: context.colors.scrim.withValues(alpha: 0.54),
    transitionDuration: AppMotion.medium,
    pageBuilder: (_, __, ___) => _DrawAnimation(names: names),
    transitionBuilder: (_, Animation<double> animation, __, Widget child) {
      final Animation<double> curved =
          CurvedAnimation(parent: animation, curve: AppMotion.emphasized);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _DrawAnimation extends StatefulWidget {
  const _DrawAnimation({required this.names});

  final List<String> names;

  @override
  State<_DrawAnimation> createState() => _DrawAnimationState();
}

class _DrawAnimationState extends State<_DrawAnimation>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 1600);

  /// How many names flash by; they slow down towards the end.
  static const int _ticks = 22;

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: _duration)
        ..forward().whenComplete(_finish);

  void _finish() {
    HapticFeedback.mediumImpact();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: RepaintBoundary(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: SizedBox(
                width: 220,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, _) {
                    final double t = _controller.value;
                    final double eased = Curves.easeOutCubic.transform(t);
                    final String name = widget
                        .names[(eased * _ticks).floor() % widget.names.length];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Transform.rotate(
                          angle: math.sin(t * math.pi * 10) * 0.12 * (1 - t),
                          child: const BrandMark(size: 72),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            context.l10n.drawing,
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ExcludeSemantics(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineSmall,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
