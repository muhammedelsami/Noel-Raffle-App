import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';

/// The app mark: a gift with a gold ribbon on a cranberry tile.
///
/// It is painted in code, so it stays sharp at any size and costs no asset
/// decoding. The launcher icon is rendered from the same painter.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 48, this.elevated = false});

  final double size;

  /// Adds a soft drop shadow, for the mark on a colored background.
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    Widget mark = SizedBox.square(
      dimension: size,
      child: const CustomPaint(painter: BrandMarkPainter()),
    );
    if (elevated) {
      mark = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            size * BrandMarkPainter.defaultCornerRadius,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: size * 0.3,
              offset: Offset(0, size * 0.14),
            ),
          ],
        ),
        child: mark,
      );
    }
    return ExcludeSemantics(child: mark);
  }
}

/// The mark followed by the app name.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.markSize = 36});

  final double markSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BrandMark(size: markSize),
          SizedBox(width: markSize / 3),
          Text(context.l10n.appName, style: context.textTheme.titleLarge),
        ],
      ),
    );
  }
}

/// Paints the mark into a square canvas.
class BrandMarkPainter extends CustomPainter {
  const BrandMarkPainter({
    this.cornerRadius = defaultCornerRadius,
    this.background = true,
  });

  static const double defaultCornerRadius = 0.28;

  /// Tile corner radius as a fraction of the size; 0 paints a full-bleed
  /// square, as app icon masks expect.
  final double cornerRadius;

  /// Paints the gradient tile; off for an adaptive icon foreground.
  final bool background;

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.shortestSide;
    final Rect bounds = Offset.zero & Size.square(s);
    Rect box(double l, double t, double r, double b) =>
        Rect.fromLTRB(l * s, t * s, r * s, b * s);

    if (background) {
      final RRect tile =
          RRect.fromRectAndRadius(bounds, Radius.circular(s * cornerRadius));
      canvas
        ..drawRRect(
          tile,
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[AppColors.cranberry, AppColors.cranberryDeep],
            ).createShader(bounds),
        )
        ..drawRRect(
          tile,
          Paint()
            ..shader = RadialGradient(
              center: const Alignment(-0.7, -0.8),
              radius: 0.9,
              colors: <Color>[
                AppColors.snow.withValues(alpha: 0.2),
                AppColors.snow.withValues(alpha: 0),
              ],
            ).createShader(bounds),
        );
      if (cornerRadius > 0) {
        // A faint inner rim keeps the tile defined on red backgrounds.
        canvas.drawRRect(
          tile.deflate(s * 0.006),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = s * 0.012
            ..color = AppColors.snow.withValues(alpha: 0.18),
        );
      }
    }

    final Paint snow = Paint()..color = AppColors.snow;
    final Paint gold = Paint()..color = AppColors.gold;
    final Paint bow = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.045;

    // Bow loops, tilted away from the knot.
    const double tilt = 0.46;
    for (final (double dx, double angle) in <(double, double)>[
      (0.41, tilt),
      (0.59, -tilt),
    ]) {
      canvas
        ..save()
        ..translate(dx * s, 0.345 * s)
        ..rotate(angle)
        ..drawOval(
          Rect.fromCenter(
              center: Offset.zero, width: s * 0.2, height: s * 0.11),
          bow,
        )
        ..restore();
    }

    // Lid, box and ribbon.
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(
          box(0.2, 0.4, 0.8, 0.52),
          Radius.circular(s * 0.04),
        ),
        snow,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          box(0.25, 0.545, 0.75, 0.8),
          Radius.circular(s * 0.045),
        ),
        snow,
      )
      ..drawRect(box(0.455, 0.4, 0.545, 0.8), gold)
      ..drawCircle(Offset(0.5 * s, 0.39 * s), s * 0.045, gold);

    _sparkle(canvas, Offset(0.79 * s, 0.22 * s), s * 0.075, gold);
    _sparkle(
      canvas,
      Offset(0.21 * s, 0.25 * s),
      s * 0.04,
      Paint()..color = AppColors.snow.withValues(alpha: 0.75),
    );
  }

  /// A four-pointed star with concave sides.
  void _sparkle(Canvas canvas, Offset c, double r, Paint paint) {
    final Path path = Path()..moveTo(c.dx, c.dy - r);
    for (int i = 1; i <= 4; i++) {
      final double angle = -math.pi / 2 + i * math.pi / 2;
      path.quadraticBezierTo(
        c.dx,
        c.dy,
        c.dx + r * math.cos(angle),
        c.dy + r * math.sin(angle),
      );
    }
    canvas.drawPath(path..close(), paint);
  }

  @override
  bool shouldRepaint(BrandMarkPainter oldDelegate) =>
      oldDelegate.cornerRadius != cornerRadius ||
      oldDelegate.background != background;
}
