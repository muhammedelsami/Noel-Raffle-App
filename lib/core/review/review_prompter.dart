import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Asks for a store review once, after a few finished draws.
///
/// The stores decide whether the review sheet really shows (they limit how
/// often it may), so this only picks the moment: back on the home screen
/// after the [drawsBeforeAsking]th draw, never in the middle of a raffle.
class ReviewPrompter {
  ReviewPrompter(this._prefs, {InAppReview? review})
      : _review = review ?? InAppReview.instance;

  static const int drawsBeforeAsking = 3;
  static const String drawCountKey = 'review_draw_count';
  static const String askedKey = 'review_asked';

  final SharedPreferences _prefs;
  final InAppReview _review;

  /// Counts a finished draw and asks for a review when it is time.
  Future<void> onDrawFinished() async {
    try {
      if (_prefs.getBool(askedKey) ?? false) return;
      final int draws = (_prefs.getInt(drawCountKey) ?? 0) + 1;
      await _prefs.setInt(drawCountKey, draws);
      if (draws < drawsBeforeAsking || !await _review.isAvailable()) return;
      await _prefs.setBool(askedKey, true);
      await _review.requestReview();
    } catch (_) {
      // A review prompt is never worth an error.
    }
  }
}
