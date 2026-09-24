/// Local notifications that remind about a raffle's gift day.
abstract interface class ReminderScheduler {
  /// Asks the user to allow notifications. Returns whether they are allowed.
  Future<bool> requestPermission();

  /// Shows a notification at [at], replacing any earlier reminder of the
  /// raffle with [raffleId].
  Future<void> schedule({
    required String raffleId,
    required DateTime at,
    required String title,
    required String body,
  });

  /// Removes the pending reminder of the raffle with [raffleId], if any.
  Future<void> cancel(String raffleId);
}
