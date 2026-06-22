import '../entities/gift.dart';
import '../entities/participant.dart';
import '../entities/raffle_config.dart';
import '../repositories/raffle_repository.dart';

/// Submits a raffle. Encapsulates the single business action so the
/// presentation layer never touches repositories directly.
class CreateRaffle {
  const CreateRaffle(this._repository);

  final RaffleRepository _repository;

  Future<void> call({
    required RaffleConfig config,
    required List<Participant> participants,
    List<Gift> gifts = const <Gift>[],
  }) {
    return _repository.submit(
      config: config,
      participants: participants,
      gifts: gifts,
    );
  }
}
