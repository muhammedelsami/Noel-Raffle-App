import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../domain/entities/raffle_type.dart';
import '../models/raffle_request_model.dart';

/// Talks to the raffle creation endpoints.
abstract interface class RaffleRemoteDataSource {
  Future<void> create(RaffleType type, RaffleRequestModel request);
}

class RaffleRemoteDataSourceImpl implements RaffleRemoteDataSource {
  const RaffleRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<void> create(RaffleType type, RaffleRequestModel request) {
    final String url = switch (type) {
      RaffleType.newYear => ApiEndpoints.newYearRaffle,
      RaffleType.gift => ApiEndpoints.giftRaffle,
    };
    return _client.post(url, body: request.toJson());
  }
}
