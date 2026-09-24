part of 'raffle_result_cubit.dart';

enum PublishStatus { idle, publishing, published, failure }

class RaffleResultState extends Equatable {
  const RaffleResultState({
    required this.raffle,
    this.revealed = const <int>{},
    this.publishStatus = PublishStatus.idle,
  });

  final Raffle raffle;

  /// Indexes of participants who already looked at their secret result.
  final Set<int> revealed;
  final PublishStatus publishStatus;

  bool get isPublishing => publishStatus == PublishStatus.publishing;

  RaffleResultState copyWith({
    Raffle? raffle,
    Set<int>? revealed,
    PublishStatus? publishStatus,
  }) {
    return RaffleResultState(
      raffle: raffle ?? this.raffle,
      revealed: revealed ?? this.revealed,
      publishStatus: publishStatus ?? this.publishStatus,
    );
  }

  @override
  List<Object?> get props => <Object?>[raffle, revealed, publishStatus];
}
