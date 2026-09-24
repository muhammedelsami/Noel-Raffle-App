part of 'raffle_draw_cubit.dart';

enum RaffleDrawStatus { initial, drawing, success, failure }

class RaffleDrawState extends Equatable {
  const RaffleDrawState({
    this.status = RaffleDrawStatus.initial,
    this.raffle,
    this.violation,
  });

  final RaffleDrawStatus status;

  /// The drawn raffle once [status] is success.
  final Raffle? raffle;

  /// Set on failure when the input broke a raffle rule.
  final RaffleRuleViolation? violation;

  bool get isDrawing => status == RaffleDrawStatus.drawing;

  @override
  List<Object?> get props => <Object?>[status, raffle, violation];
}
