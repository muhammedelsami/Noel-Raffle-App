import '../entities/raffle.dart';
import '../repositories/online_raffle_repository.dart';
import '../repositories/raffle_history_repository.dart';
import '../repositories/reminder_scheduler.dart';

/// Removes a raffle from the history and, when it was published, its online
/// results too. A pending reminder is cancelled.
class DeleteRaffle {
  const DeleteRaffle(this._history, this._online, this._reminders);

  final RaffleHistoryRepository _history;
  final OnlineRaffleRepository _online;
  final ReminderScheduler _reminders;

  Future<void> call(Raffle raffle) async {
    if (raffle.isPublished && _online.isAvailable) {
      try {
        await _online.unpublish(raffle);
      } catch (_) {
        // Deleting locally must still work offline; the codes stay online.
      }
    }
    if (raffle.config.remind) {
      try {
        await _reminders.cancel(raffle.id);
      } catch (_) {
        // A reminder that cannot be cancelled still fires once; harmless.
      }
    }
    await _history.delete(raffle.id);
  }
}
