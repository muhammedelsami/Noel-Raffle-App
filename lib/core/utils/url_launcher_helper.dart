import 'package:url_launcher/url_launcher.dart';

/// Opens external URLs using the modern url_launcher API.
abstract final class UrlLauncherHelper {
  /// Returns `false` when no app can handle [url].
  static Future<bool> open(String url) {
    return _launch(Uri.parse(url), LaunchMode.externalApplication);
  }

  /// Opens the user's mail app with a prefilled message to [to].
  static Future<bool> email({
    required String to,
    required String subject,
    required String body,
  }) {
    // Encoded by hand: Uri.queryParameters would turn spaces into '+', which
    // many mail apps show literally.
    final Uri uri = Uri.parse(
      'mailto:${Uri.encodeComponent(to)}'
      '?subject=${Uri.encodeComponent(subject)}'
      '&body=${Uri.encodeComponent(body)}',
    );
    return _launch(uri, LaunchMode.platformDefault);
  }

  // launchUrl is used directly instead of canLaunchUrl, which needs extra
  // package-visibility declarations on Android 11+ and iOS.
  static Future<bool> _launch(Uri uri, LaunchMode mode) async {
    try {
      return await launchUrl(uri, mode: mode);
    } catch (_) {
      return false;
    }
  }
}
