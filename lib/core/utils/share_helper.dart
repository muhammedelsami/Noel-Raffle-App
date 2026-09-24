import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

/// Opens the platform share sheet (WhatsApp, SMS, mail, ...).
///
/// [context] should belong to the widget that triggered the share; iPads
/// anchor the share popover to it.
abstract final class ShareHelper {
  static Future<void> shareText(
    BuildContext context,
    String text, {
    String? subject,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject,
        sharePositionOrigin: _origin(context),
      ),
    );
  }

  /// Shares a PNG image, e.g. a rendered result card.
  static Future<void> shareImage(
    BuildContext context,
    Uint8List png, {
    required String fileName,
    String? subject,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        files: <XFile>[XFile.fromData(png, mimeType: 'image/png')],
        fileNameOverrides: <String>[fileName],
        subject: subject,
        sharePositionOrigin: _origin(context),
      ),
    );
  }

  static Rect? _origin(BuildContext context) {
    final RenderObject? box = context.findRenderObject();
    return box is RenderBox && box.hasSize
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
  }
}
