import '../../domain/entities/raffle.dart';
import '../../domain/repositories/raffle_history_repository.dart';
import '../datasources/raffle_local_data_source.dart';

class RaffleHistoryRepositoryImpl implements RaffleHistoryRepository {
  const RaffleHistoryRepositoryImpl(this._local);

  final RaffleLocalDataSource _local;

  @override
  Future<List<Raffle>> getAll() async {
    final List<Raffle> raffles = await _local.readAll();
    return raffles..sort(_newestFirst);
  }

  @override
  Future<void> save(Raffle raffle) async {
    final List<Raffle> raffles = await _local.readAll();
    final int index = raffles.indexWhere((Raffle r) => r.id == raffle.id);
    if (index >= 0) {
      raffles[index] = raffle;
    } else {
      raffles.add(raffle);
    }
    await _local.writeAll(raffles..sort(_newestFirst));
  }

  @override
  Future<void> delete(String id) async {
    final List<Raffle> raffles = await _local.readAll();
    await _local.writeAll(raffles..removeWhere((Raffle r) => r.id == id));
  }

  static int _newestFirst(Raffle a, Raffle b) =>
      b.createdAt.compareTo(a.createdAt);
}
