import 'package:flutter/widgets.dart';

/// Business and layout constants shared across the app.
abstract final class AppConstants {
  /// Minimum number of participants required before a raffle can start.
  static const int minParticipants = 3;

  /// Minimum number of gifts required for a gift raffle.
  static const int minGifts = 3;

  /// Backend gift identifier kept identical to the original API contract.
  static const String defaultGiftId = '1bc4a4af-134b-448d-afcb-162fadffb170';

  /// Numeric code used when no group/sector is chosen (legacy default).
  static const int unspecifiedCode = 100;

  /// Group options (label → backend code).
  static const Map<String, int> groupOptions = <String, int>{
    'Ekip-Şirket': 10,
    'Arkadaş-Sınıf': 20,
    'Aile-Akraba': 30,
    'Diğer': 40,
  };

  /// Sector options (label → backend code).
  static const Map<String, int> sectorOptions = <String, int>{
    'Teknoloji': 10,
    'Eğitim': 20,
    'Gıda': 30,
    'Sağlık': 40,
    'Spor': 50,
    'Diğer': 60,
  };

  // External links.
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.muhammed.noel_raffle';
  static const String websiteUrl = 'https://www.noelraffle.com/tr';
  static const String repoUrl = 'https://github.com/edabarutcu/Noel-Raffle-App';

  // Splash timing.
  static const Duration splashDuration = Duration(seconds: 3);

  // Common layout values.
  static const double pagePadding = 24;
  static const double cardRadius = 16;
  static const double fieldRadius = 14;

  /// Margin between a modal and the screen edges. Kept tight so dialogs feel
  /// wide and modern instead of cramped in the center.
  static const EdgeInsets dialogInset =
      EdgeInsets.symmetric(horizontal: 20, vertical: 24);
}
