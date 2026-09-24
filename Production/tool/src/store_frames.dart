import 'package:flutter/material.dart';
import 'package:noel_raffle/core/constants/app_assets.dart';
import 'package:noel_raffle/core/theme/app_colors.dart';
import 'package:noel_raffle/core/theme/app_typography.dart';
import 'package:noel_raffle/core/theme/brand_colors.dart';
import 'package:noel_raffle/presentation/widgets/brand_mark.dart';
import 'package:noel_raffle/presentation/widgets/illustration.dart';

import 'app_scenes.dart';
import 'store_locale.dart';

/// Logical size of a phone screenshot; rendered at 3x (1080 × 1920 px).
const Size screenshotSize = Size(360, 640);

/// Logical size of the feature graphic; rendered at 2x (1024 × 500 px).
const Size featureGraphicSize = Size(512, 250);

const TextStyle _headline = TextStyle(
  fontFamily: AppFonts.body,
  fontSize: 27,
  fontWeight: FontWeight.w700,
  height: 1.2,
  letterSpacing: -0.3,
  color: AppColors.snow,
);

/// An annotated store screenshot: a caption over the brand gradient and the
/// app running on one or two phones.
class StoreScreenshot extends StatelessWidget {
  const StoreScreenshot({
    super.key,
    required this.caption,
    required this.screens,
  });

  final Caption caption;
  final List<PhoneScreen> screens;

  @override
  Widget build(BuildContext context) {
    // Arabic script has tall marks above and below the line; give it room.
    final double leading =
        Directionality.of(context) == TextDirection.rtl ? 1.25 : 1;
    return _BrandBackdrop(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 44,
            left: 24,
            right: 24,
            child: Column(
              children: <Widget>[
                Text(
                  caption.headline,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: _headline.copyWith(height: 1.2 * leading),
                ),
                SizedBox(height: 10 * leading),
                Text(
                  caption.subline,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: _headline.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.4 * leading,
                    letterSpacing: 0,
                    color: AppColors.snow.withValues(alpha: 0.88),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            // One phone bleeds off the bottom; two are centered below.
            top: screens.length == 1 ? 190 : 214,
            left: 0,
            right: 0,
            child: screens.length == 1
                ? Center(child: PhoneFrame(screen: screens.single, width: 268))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      PhoneFrame(screen: screens.first, width: 162),
                      const SizedBox(width: 14),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: PhoneFrame(screen: screens.last, width: 162),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// A modern phone with a punch-hole camera, a status bar and a gesture bar
/// around a captured app screen, scaled to [width].
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.screen, required this.width});

  static const double _bezel = 14;

  final PhoneScreen screen;
  final double width;

  @override
  Widget build(BuildContext context) {
    final Color ink = screen.dark ? AppColors.snow : AppColors.light.onSurface;
    return SizedBox(
      width: width,
      child: FittedBox(
        child: Container(
          width: AppScenes.phoneSize.width + 2 * _bezel,
          height: AppScenes.phoneSize.height + 2 * _bezel,
          padding: const EdgeInsets.all(_bezel),
          decoration: BoxDecoration(
            color: const Color(0xFF111114),
            borderRadius: BorderRadius.circular(58),
            border: Border.all(color: const Color(0xFF3B3B40), width: 2),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 60,
                offset: Offset(0, 30),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(44),
            child: Stack(
              children: <Widget>[
                RawImage(
                  image: screen.image,
                  width: AppScenes.phoneSize.width,
                  height: AppScenes.phoneSize.height,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
                _StatusBar(color: ink),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 108,
                      height: 5,
                      decoration: BoxDecoration(
                        color: ink.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: Stack(
        children: <Widget>[
          const Align(
            alignment: Alignment(0, -0.1),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFF050507),
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(dimension: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              children: <Widget>[
                Text(
                  '9:41',
                  style: TextStyle(
                    fontFamily: AppFonts.body,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const Spacer(),
                Icon(Icons.signal_cellular_alt_rounded, size: 17, color: color),
                const SizedBox(width: 4),
                Icon(Icons.wifi_rounded, size: 17, color: color),
                const SizedBox(width: 4),
                Icon(Icons.battery_full_rounded, size: 17, color: color),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The 1024 × 500 banner at the top of the store listing.
class FeatureGraphic extends StatelessWidget {
  const FeatureGraphic({super.key, required this.tagline});

  final String tagline;

  @override
  Widget build(BuildContext context) {
    return _BrandBackdrop(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 24, 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const BrandMark(size: 56, elevated: true),
                  const SizedBox(height: 16),
                  const Text(
                    'Noel Raffle',
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                      letterSpacing: -0.6,
                      color: AppColors.snow,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tagline,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      fontSize: 16,
                      height: 1.35,
                      color: AppColors.snow.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 200,
              height: 250,
              child: Stack(
                children: <Widget>[
                  PositionedDirectional(
                    end: 0,
                    top: 24,
                    child: Illustration(AppAssets.giftBox, size: 150),
                  ),
                  PositionedDirectional(
                    start: 0,
                    bottom: 12,
                    child: Illustration(AppAssets.giftHand, size: 116),
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

/// The brand gradient with soft light circles and gold sparkles.
class _BrandBackdrop extends StatelessWidget {
  const _BrandBackdrop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: BrandColors.light.heroGradient),
      child: CustomPaint(painter: const _BackdropPainter(), child: child),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  const _BackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint glow = Paint()..color = AppColors.snow.withValues(alpha: 0.06);
    canvas
      ..drawCircle(
        Offset(size.width * 0.95, size.height * 0.02),
        size.shortestSide * 0.55,
        glow,
      )
      ..drawCircle(
        Offset(size.width * 0.02, size.height * 0.98),
        size.shortestSide * 0.45,
        glow,
      );

    final Paint gold = Paint()..color = AppColors.gold;
    final Paint snow = Paint()..color = AppColors.snow.withValues(alpha: 0.7);
    final double unit = size.shortestSide;
    BrandMarkPainter.paintSparkle(
      canvas,
      Offset(size.width * 0.08, size.height * 0.05),
      unit * 0.03,
      gold,
    );
    BrandMarkPainter.paintSparkle(
      canvas,
      Offset(size.width * 0.93, size.height * 0.31),
      unit * 0.022,
      gold,
    );
    BrandMarkPainter.paintSparkle(
      canvas,
      Offset(size.width * 0.05, size.height * 0.27),
      unit * 0.015,
      snow,
    );
    BrandMarkPainter.paintSparkle(
      canvas,
      Offset(size.width * 0.55, size.height * 0.93),
      unit * 0.018,
      snow,
    );
  }

  @override
  bool shouldRepaint(_BackdropPainter oldDelegate) => false;
}
