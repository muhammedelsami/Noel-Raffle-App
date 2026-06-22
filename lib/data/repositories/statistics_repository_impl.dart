import '../../domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_remote_data_source.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  const StatisticsRepositoryImpl(this._remote);

  final StatisticsRemoteDataSource _remote;

  @override
  Future<Statistics> fetch() => _remote.fetch();
}
