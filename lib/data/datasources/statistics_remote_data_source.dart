import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/statistics_model.dart';

/// Talks to the statistics endpoint.
abstract interface class StatisticsRemoteDataSource {
  Future<StatisticsModel> fetch();
}

class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  const StatisticsRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<StatisticsModel> fetch() async {
    final Map<String, dynamic> json =
        await _client.post(ApiEndpoints.statistics);
    return StatisticsModel.fromJson(json);
  }
}
