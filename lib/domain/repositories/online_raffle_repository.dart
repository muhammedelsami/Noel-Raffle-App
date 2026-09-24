import '../entities/raffle.dart';
import '../entities/shared_result.dart';
import '../entities/statistics.dart';

/// Optional cloud features (Firebase). When the app runs without a configured
/// Firebase project [isAvailable] is `false` and the other methods throw.
abstract interface class OnlineRaffleRepository {
  bool get isAvailable;

  /// Uploads one result per participant and returns [raffle] with each
  /// assignment's personal code filled in.
  Future<Raffle> publish(Raffle raffle);

  /// Removes the uploaded results of a published [raffle].
  Future<void> unpublish(Raffle raffle);

  /// Fetches the result behind a normalized share [code].
  Future<SharedResult> lookup(String code);

  /// Adds [raffle] to the global usage counters.
  Future<void> recordStatistics(Raffle raffle);

  Future<Statistics> fetchGlobalStatistics();
}
