import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/gift.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/raffle.dart';
import '../../../domain/entities/raffle_config.dart';
import '../../../domain/entities/raffle_rules.dart';
import '../../../domain/usecases/create_raffle.dart';

part 'raffle_draw_state.dart';

/// Draws a completed raffle on the device and saves it to the history.
class RaffleDrawCubit extends Cubit<RaffleDrawState> {
  RaffleDrawCubit(this._createRaffle) : super(const RaffleDrawState());

  final CreateRaffle _createRaffle;

  Future<void> draw({
    required RaffleConfig config,
    required List<Participant> participants,
    List<Gift> gifts = const <Gift>[],
  }) async {
    if (state.isDrawing) return;
    emit(const RaffleDrawState(status: RaffleDrawStatus.drawing));
    try {
      final Raffle raffle = await _createRaffle(
        config: config,
        participants: participants,
        gifts: gifts,
      );
      emit(RaffleDrawState(status: RaffleDrawStatus.success, raffle: raffle));
    } on RaffleRuleException catch (e) {
      emit(RaffleDrawState(
        status: RaffleDrawStatus.failure,
        violation: e.violation,
      ));
    } catch (_) {
      // The UI shows a localized generic error for any other failure.
      emit(const RaffleDrawState(status: RaffleDrawStatus.failure));
    }
  }
}
