import 'package:flutter/widgets.dart';

/// Layout constants, input limits and external links shared across the app.
/// Raffle business rules live in the domain (`RaffleRules`).
abstract final class AppConstants {
  // Input limits. The Firestore rules accept a bit more, so these always pass.
  static const int maxTitleLength = 80;
  static const int maxNoteLength = 300;
  static const int maxNameLength = 60;

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
