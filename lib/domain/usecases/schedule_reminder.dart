import '../entities/raffle.dart';
import '../repositories/reminder_scheduler.dart';

/// Reminds about a raffle's gift day with a local notification, when the
/// raffle asks for one.
class ScheduleReminder {
  ScheduleReminder(this._scheduler, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  static const int dayBeforeHour = 10;
  static const int sameDayHour = 9;

  final ReminderScheduler _scheduler;
  final DateTime Function() _clock;

  /// When to remind about a gift day on [day]: at 10:00 the day before, or at
  /// 9:00 on the day itself once that has passed. `null` when both have.
  static DateTime? reminderTime(DateTime day, DateTime now) {
    final DateTime dayBefore =
        DateTime(day.year, day.month, day.day - 1, dayBeforeHour);
    if (dayBefore.isAfter(now)) return dayBefore;
    final DateTime sameDay =
        DateTime(day.year, day.month, day.day, sameDayHour);
    return sameDay.isAfter(now) ? sameDay : null;
  }

  Future<bool> requestPermission() async {
    try {
      return await _scheduler.requestPermission();
    } catch (_) {
      return false;
    }
  }

  /// Schedules the reminder and returns when it fires, or `null` when
  /// [raffle] needs none or it could not be scheduled. Never throws: a
  /// missing reminder must not get in the way of the draw.
  Future<DateTime?> call(
    Raffle raffle, {
    required String title,
    required String body,
  }) async {
    final DateTime? day = raffle.config.eventDate;
    if (!raffle.config.remind || day == null) return null;
    final DateTime? at = reminderTime(day, _clock());
    if (at == null) return null;
    try {
      await _scheduler.schedule(
        raffleId: raffle.id,
        at: at,
        title: title,
        body: body,
      );
      return at;
    } catch (_) {
      return null;
    }
  }
}
