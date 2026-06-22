import '../entities/gift.dart';
import '../entities/participant.dart';
import '../entities/raffle_config.dart';

/// Contract for submitting a completed raffle to the backend.
abstract interface class RaffleRepository {
  /// Sends the raffle. [gifts] is only used for gift raffles.
  Future<void> submit({
    required RaffleConfig config,
    required List<Participant> participants,
    List<Gift> gifts = const <Gift>[],
  });
}
