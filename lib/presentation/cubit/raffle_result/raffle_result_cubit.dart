import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/raffle.dart';
import '../../../domain/usecases/publish_raffle.dart';

part 'raffle_result_state.dart';

/// Backs the result screen: tracks which secret results have been revealed
/// and publishes personal online codes.
class RaffleResultCubit extends Cubit<RaffleResultState> {
  RaffleResultCubit(this._publishRaffle, Raffle raffle)
      : super(RaffleResultState(
          raffle: raffle,
          publishStatus:
              raffle.isPublished ? PublishStatus.published : PublishStatus.idle,
        ));

  final PublishRaffle _publishRaffle;

  /// Whether online codes can be created (Firebase is configured).
  bool get canPublish => _publishRaffle.isAvailable;

  /// Remembers that the participant at [index] has seen their result.
  void markRevealed(int index) {
    if (state.revealed.contains(index)) return;
    emit(state.copyWith(revealed: <int>{...state.revealed, index}));
  }

  Future<void> publish() async {
    if (state.raffle.isPublished || state.isPublishing) return;
    emit(state.copyWith(publishStatus: PublishStatus.publishing));
    try {
      final Raffle raffle = await _publishRaffle(state.raffle);
      emit(state.copyWith(
        raffle: raffle,
        publishStatus: PublishStatus.published,
      ));
    } catch (_) {
      emit(state.copyWith(publishStatus: PublishStatus.failure));
    }
  }
}
