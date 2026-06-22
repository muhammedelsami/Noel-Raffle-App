import '../entities/statistics.dart';

/// Contract for fetching aggregate raffle statistics.
abstract interface class StatisticsRepository {
  Future<Statistics> fetch();
}
