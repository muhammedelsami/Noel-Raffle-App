import '../entities/statistics.dart';
import '../repositories/online_raffle_repository.dart';

/// Totals across all users, kept in the cloud.
class GetGlobalStatistics {
  const GetGlobalStatistics(this._online);

  final OnlineRaffleRepository _online;

  bool get isAvailable => _online.isAvailable;

  Future<Statistics> call() => _online.fetchGlobalStatistics();
}
