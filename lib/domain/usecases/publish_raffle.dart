import '../entities/raffle.dart';
import '../repositories/online_raffle_repository.dart';
import '../repositories/raffle_history_repository.dart';

/// Creates personal online codes for every participant and remembers them in
/// the local history. Publishing an already published raffle is a no-op.
class PublishRaffle {
  const PublishRaffle(this._online, this._history);

  final OnlineRaffleRepository _online;
  final RaffleHistoryRepository _history;

  bool get isAvailable => _online.isAvailable;

  Future<Raffle> call(Raffle raffle) async {
    if (raffle.isPublished) return raffle;
    final Raffle published = await _online.publish(raffle);
    await _history.save(published);
    return published;
  }
}
