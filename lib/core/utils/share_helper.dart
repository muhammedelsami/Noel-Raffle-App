import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

/// Opens the platform share sheet (WhatsApp, SMS, mail, ...).
abstract final class ShareHelper {
  /// [context] should belong to the widget that triggered the share; iPads
  /// anchor the share popover to it.
  static Future<void> shareText(
    BuildContext context,
    String text, {
    String? subject,
  }) async {
    final RenderObject? box = context.findRenderObject();
    final Rect? origin = box is RenderBox && box.hasSize
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    await SharePlus.instance.share(
      ShareParams(text: text, subject: subject, sharePositionOrigin: origin),
    );
  }
}
