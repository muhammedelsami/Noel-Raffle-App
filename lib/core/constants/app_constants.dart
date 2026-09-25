import 'package:flutter/widgets.dart';

/// Input limits, external links and layout limits shared across the app.
/// Raffle business rules live in the domain (`RaffleRules`); spacing, radii
/// and motion tokens live in `core/theme/app_dimens.dart`.
abstract final class AppConstants {
  // Input limits. The Firestore rules accept a bit more, so these always pass.
  static const int maxTitleLength = 80;
  static const int maxNoteLength = 300;
  static const int maxNameLength = 60;
  static const int maxWishLength = 200;
  static const int maxGiftCountDigits = 3;
  static const int maxCodeLength = 12;

  // External links.
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.muhammed.noel_raffle';
  static const String websiteUrl = 'https://noelraffle.vercel.app';
  static const String repoUrl = 'https://github.com/muhammedelsami/Noel-Raffle-App';

  // Splash timing.
  static const Duration splashDuration = Duration(milliseconds: 1600);

  /// Content never grows wider than this, so tablets and landscape phones
  /// keep a readable line length.
  static const double maxContentWidth = 640;

  /// From this window width on (Material's "expanded" size), screens made of
  /// cards place them side by side, up to [maxWideContentWidth].
  static const double wideLayoutBreakpoint = 840;
  static const double maxWideContentWidth = 1040;

  /// Margin between a modal and the screen edges.
  static const EdgeInsets dialogInset =
      EdgeInsets.symmetric(horizontal: 20, vertical: 24);
}
