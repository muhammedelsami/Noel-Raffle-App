import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

/// Writes [image] as a 24-bit PNG. Google Play rejects screenshots and
/// feature graphics that carry an alpha channel.
Future<void> writeOpaquePng(ui.Image image, String path) async {
  final ByteData? rgba =
      await image.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
  final img.Image rgb = img.Image.fromBytes(
    image.width,
    image.height,
    rgba!.buffer.asUint8List(),
    channels: img.Channels.rgb,
  );
  final File file = File(path);
  await file.parent.create(recursive: true);
  await file.writeAsBytes(img.encodePng(rgb));
}
