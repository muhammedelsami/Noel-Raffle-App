import '../entities/raffle.dart';
import '../repositories/online_raffle_repository.dart';
import '../repositories/raffle_history_repository.dart';

/// Removes a raffle from the history and, when it was published, its online
/// results too.
class DeleteRaffle {
  const DeleteRaffle(this._history, this._online);

  final RaffleHistoryRepository _history;
  final OnlineRaffleRepository _online;

  Future<void> call(Raffle raffle) async {
    if (raffle.isPublished && _online.isAvailable) {
      try {
        await _online.unpublish(raffle);
      } catch (_) {
        // Deleting locally must still work offline; the codes stay online.
      }
    }
    await _history.delete(raffle.id);
  }
}
