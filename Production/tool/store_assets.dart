/// Renders the Google Play listing artwork for every store language into
/// `Production/metadata/android/<language>/images/`:
///
/// * `icon.png`: 512 × 512 app icon,
/// * `featureGraphic.png`: 1024 × 500 banner,
/// * `phoneScreenshots/`: annotated 1080 × 1920 screenshots of the real app.
///
/// Run it from the project root after UI changes:
///
///     flutter test Production/tool/store_assets.dart
library;

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/presentation/widgets/brand_mark.dart';

import 'src/app_scenes.dart';
import 'src/png_writer.dart';
import 'src/store_frames.dart';
import 'src/store_locale.dart';

const String _metadataDir = 'Production/metadata/android';

void main() {
  setUpAll(() async {
    await _loadBundledFonts();
    for (final StoreLocale store in StoreLocale.values) {
      final Directory shots = Directory(_screenshotsDir(store));
      if (shots.existsSync()) shots.deleteSync(recursive: true);
    }
  });

  for (final StoreLocale store in StoreLocale.values) {
    group(store.playCode, () {
      testWidgets('icon', (WidgetTester tester) async {
        await tester.runAsync(() async {
          await writeOpaquePng(
              await _paintIcon(512), _imagePath(store, 'icon'));
        });
      });

      testWidgets('feature graphic', (WidgetTester tester) async {
        await _renderArtwork(
          tester,
          store,
          size: featureGraphicSize,
          pixelRatio: 2,
          path: _imagePath(store, 'featureGraphic'),
          child: FeatureGraphic(tagline: store.tagline),
        );
      });

      for (final StoreShot shot in StoreShot.values) {
        testWidgets('screenshot ${shot.name}', (WidgetTester tester) async {
          final List<PhoneScreen> screens =
              await AppScenes(tester, store).capture(shot);
          await _renderArtwork(
            tester,
            store,
            size: screenshotSize,
            pixelRatio: 3,
            path: '${_screenshotsDir(store)}/'
                '${shot.index + 1}_${shot.name}.png',
            child: StoreScreenshot(
              caption: store.captions[shot]!,
              screens: screens,
            ),
          );
        });
      }
    });
  }
}

String _imagePath(StoreLocale store, String name) =>
    '$_metadataDir/${store.playCode}/images/$name.png';

String _screenshotsDir(StoreLocale store) =>
    '$_metadataDir/${store.playCode}/images/phoneScreenshots';

/// Registers every font the app bundles (Alexandria, Material Icons, ...),
/// since widget tests otherwise draw text with a placeholder font.
Future<void> _loadBundledFonts() async {
  final List<dynamic> manifest =
      json.decode(await rootBundle.loadString('FontManifest.json'))
          as List<dynamic>;
  for (final dynamic entry in manifest) {
    final Map<String, dynamic> family = entry as Map<String, dynamic>;
    final FontLoader loader = FontLoader(family['family'] as String);
    for (final dynamic font in family['fonts'] as List<dynamic>) {
      loader.addFont(
        rootBundle.load((font as Map<String, dynamic>)['asset'] as String),
      );
    }
    await loader.load();
  }
}

Future<ui.Image> _paintIcon(int size) {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  const BrandMarkPainter(cornerRadius: 0)
      .paint(Canvas(recorder), Size.square(size.toDouble()));
  return recorder.endRecording().toImage(size, size);
}

/// Lays [child] out at [size] in the store language and saves it as a PNG.
Future<void> _renderArtwork(
  WidgetTester tester,
  StoreLocale store, {
  required Size size,
  required double pixelRatio,
  required String path,
  required Widget child,
}) async {
  tester.view
    ..physicalSize = size * pixelRatio
    ..devicePixelRatio = pixelRatio
    ..resetPadding()
    ..resetViewPadding();
  addTearDown(tester.view.reset);

  // Widget tests draw shadows without blur by default; the artwork needs
  // the real, soft ones.
  debugDisableShadows = false;
  try {
    final GlobalKey boundary = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: boundary,
        child: Directionality(
          textDirection: store.textDirection,
          child: MediaQuery(
            data: MediaQueryData(size: size, devicePixelRatio: pixelRatio),
            child: child,
          ),
        ),
      ),
    );
    final RenderRepaintBoundary render =
        boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await precacheIllustrations(tester, find.byKey(boundary));
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await writeOpaquePng(
        await render.toImage(pixelRatio: pixelRatio),
        path,
      );
    });
  } finally {
    debugDisableShadows = true;
  }
}
