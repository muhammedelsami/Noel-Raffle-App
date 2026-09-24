import 'package:noel_raffle/domain/repositories/reminder_scheduler.dart';

/// Keeps scheduled reminders in memory instead of showing notifications.
class RecordingReminders implements ReminderScheduler {
  RecordingReminders({this.allowed = true});

  /// What [requestPermission] answers.
  bool allowed;
  bool failing = false;

  final Map<String, ({DateTime at, String title, String body})> scheduled =
      <String, ({DateTime at, String title, String body})>{};

  @override
  Future<bool> requestPermission() async => allowed;

  @override
  Future<void> schedule({
    required String raffleId,
    required DateTime at,
    required String title,
    required String body,
  }) async {
    if (failing) throw StateError('notifications unavailable');
    scheduled[raffleId] = (at: at, title: title, body: body);
  }

  @override
  Future<void> cancel(String raffleId) async => scheduled.remove(raffleId);
}
