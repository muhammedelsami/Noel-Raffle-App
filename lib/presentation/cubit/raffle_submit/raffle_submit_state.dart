part of 'raffle_submit_cubit.dart';

enum RaffleSubmitStatus { initial, loading, success, failure }

class RaffleSubmitState extends Equatable {
  const RaffleSubmitState({
    this.status = RaffleSubmitStatus.initial,
    this.error,
  });

  final RaffleSubmitStatus status;
  final String? error;

  bool get isLoading => status == RaffleSubmitStatus.loading;

  @override
  List<Object?> get props => <Object?>[status, error];
}
