import '../entities/raffle.dart';
import '../repositories/raffle_history_repository.dart';

/// Lists the raffles drawn on this device, newest first.
class GetRaffleHistory {
  const GetRaffleHistory(this._history);

  final RaffleHistoryRepository _history;

  Future<List<Raffle>> call() => _history.getAll();
}
