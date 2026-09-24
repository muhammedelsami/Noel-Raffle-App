import '../entities/raffle.dart';
import '../entities/statistics.dart';
import '../repositories/raffle_history_repository.dart';

/// Totals for the raffles drawn on this device.
class GetStatistics {
  const GetStatistics(this._history);

  final RaffleHistoryRepository _history;

  Future<Statistics> call() async {
    final List<Raffle> raffles = await _history.getAll();
    return Statistics.fromRaffles(raffles);
  }
}
