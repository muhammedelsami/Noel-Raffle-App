import '../../domain/entities/gift.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/raffle_config.dart';
import '../../domain/repositories/raffle_repository.dart';
import '../datasources/raffle_remote_data_source.dart';
import '../models/raffle_request_model.dart';

class RaffleRepositoryImpl implements RaffleRepository {
  const RaffleRepositoryImpl(this._remote);

  final RaffleRemoteDataSource _remote;

  @override
  Future<void> submit({
    required RaffleConfig config,
    required List<Participant> participants,
    List<Gift> gifts = const <Gift>[],
  }) {
    final RaffleRequestModel request = RaffleRequestModel(
      config: config,
      participants: participants,
      gifts: gifts,
    );
    return _remote.create(config.type, request);
  }
}
