import '../../core/error/exceptions.dart';
import '../../domain/entities/raffle.dart';
import '../../domain/entities/shared_result.dart';
import '../../domain/entities/statistics.dart';
import '../../domain/repositories/online_raffle_repository.dart';
import '../datasources/raffle_cloud_data_source.dart';

/// Online features backed by [RaffleCloudDataSource]. Pass `null` when
/// Firebase is not configured; every call then throws
/// [CloudUnavailableException].
class OnlineRaffleRepositoryImpl implements OnlineRaffleRepository {
  const OnlineRaffleRepositoryImpl(this._cloud);

  final RaffleCloudDataSource? _cloud;

  RaffleCloudDataSource get _requireCloud =>
      _cloud ?? (throw const CloudUnavailableException());

  @override
  bool get isAvailable => _cloud != null;

  @override
  Future<Raffle> publish(Raffle raffle) async => _requireCloud.publish(raffle);

  @override
  Future<void> unpublish(Raffle raffle) async =>
      _requireCloud.unpublish(raffle);

  @override
  Future<SharedResult> lookup(String code) async => _requireCloud.lookup(code);

  @override
  Future<void> recordStatistics(Raffle raffle) async =>
      _requireCloud.recordStatistics(raffle);

  @override
  Future<Statistics> fetchGlobalStatistics() async =>
      _requireCloud.fetchStatistics();
}
