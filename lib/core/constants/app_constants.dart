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

  /// Group option backend codes, in display order. Labels are localized via
  /// `groupLabel` in `core/l10n/option_labels.dart`.
  static const List<int> groupCodes = <int>[10, 20, 30, 40];

  /// Sector option backend codes, in display order. Labels are localized via
  /// `sectorLabel` in `core/l10n/option_labels.dart`.
  static const List<int> sectorCodes = <int>[10, 20, 30, 40, 50, 60];

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
