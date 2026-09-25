import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:noel_raffle/core/review/review_prompter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeReview implements InAppReview {
  bool available = true;
  int requests = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<void> requestReview() async => requests++;

  @override
  Future<void> openStoreListing({
    String? appStoreId,
    String? microsoftStoreId,
  }) async {}
}

void main() {
  late _FakeReview review;
  late ReviewPrompter prompter;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    review = _FakeReview();
    prompter = ReviewPrompter(
      await SharedPreferences.getInstance(),
      review: review,
    );
  });

  Future<void> finishDraws(int count) async {
    for (int i = 0; i < count; i++) {
      await prompter.onDrawFinished();
    }
  }

  test('asks once, after the third draw', () async {
    await finishDraws(ReviewPrompter.drawsBeforeAsking - 1);
    expect(review.requests, 0);
    await finishDraws(1);
    expect(review.requests, 1);
    await finishDraws(5);
    expect(review.requests, 1);
  });

  test('waits for a later draw while reviews are unavailable', () async {
    review.available = false;
    await finishDraws(ReviewPrompter.drawsBeforeAsking);
    expect(review.requests, 0);
    review.available = true;
    await finishDraws(1);
    expect(review.requests, 1);
  });
}
