import 'gift.dart';
import 'participant.dart';
import 'raffle_type.dart';

/// Why a raffle cannot be drawn yet.
enum RaffleRuleViolation { notEnoughParticipants, notEnoughGifts, tooManyGifts }

/// Thrown by the drawer when the input breaks a [RaffleRules] rule.
class RaffleRuleException implements Exception {
  const RaffleRuleException(this.violation);

  final RaffleRuleViolation violation;

  @override
  String toString() => 'RaffleRuleException(${violation.name})';
}

/// Business rules a raffle must satisfy before it can be drawn.
abstract final class RaffleRules {
  /// Minimum number of participants for either raffle type.
  static const int minParticipants = 3;

  /// Minimum number of gift entries for a gift raffle.
  static const int minGifts = 1;

  /// Returns the first broken rule, or `null` when the raffle can be drawn.
  ///
  /// In a gift raffle each participant wins at most one gift, so there cannot
  /// be more gift items than participants.
  static RaffleRuleViolation? validate({
    required RaffleType type,
    required List<Participant> participants,
    List<Gift> gifts = const <Gift>[],
  }) {
    if (participants.length < minParticipants) {
      return RaffleRuleViolation.notEnoughParticipants;
    }
    if (!type.hasGifts) return null;
    if (gifts.length < minGifts) return RaffleRuleViolation.notEnoughGifts;
    final int units = gifts.fold(0, (int sum, Gift g) => sum + g.count);
    if (units > participants.length) return RaffleRuleViolation.tooManyGifts;
    return null;
  }
}
