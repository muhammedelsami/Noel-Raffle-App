import 'package:url_launcher/url_launcher.dart';

/// Opens external URLs using the modern url_launcher API.
abstract final class UrlLauncherHelper {
  static Future<bool> open(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
