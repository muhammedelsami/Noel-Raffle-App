import '../entities/statistics.dart';
import '../repositories/statistics_repository.dart';

/// Fetches aggregate raffle statistics.
class GetStatistics {
  const GetStatistics(this._repository);

  final StatisticsRepository _repository;

  Future<Statistics> call() => _repository.fetch();
}
