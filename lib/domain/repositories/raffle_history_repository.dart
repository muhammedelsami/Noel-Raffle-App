import '../entities/raffle.dart';

/// Raffles drawn on this device, kept locally.
abstract interface class RaffleHistoryRepository {
  /// All saved raffles, newest first.
  Future<List<Raffle>> getAll();

  /// Inserts [raffle], or replaces the saved raffle with the same id.
  Future<void> save(Raffle raffle);

  Future<void> delete(String id);
}
