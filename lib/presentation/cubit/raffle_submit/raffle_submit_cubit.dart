import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/gift.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/raffle_config.dart';
import '../../../domain/usecases/create_raffle.dart';

part 'raffle_submit_state.dart';

/// Drives the network submission of a completed raffle.
class RaffleSubmitCubit extends Cubit<RaffleSubmitState> {
  RaffleSubmitCubit(this._createRaffle) : super(const RaffleSubmitState());

  final CreateRaffle _createRaffle;

  Future<void> submit({
    required RaffleConfig config,
    required List<Participant> participants,
    List<Gift> gifts = const <Gift>[],
  }) async {
    emit(const RaffleSubmitState(status: RaffleSubmitStatus.loading));
    try {
      await _createRaffle(
        config: config,
        participants: participants,
        gifts: gifts,
      );
      emit(const RaffleSubmitState(status: RaffleSubmitStatus.success));
    } on ServerException catch (e) {
      emit(RaffleSubmitState(
        status: RaffleSubmitStatus.failure,
        error: e.message,
      ));
    } on NetworkException catch (e) {
      emit(RaffleSubmitState(
        status: RaffleSubmitStatus.failure,
        error: e.message,
      ));
    } catch (_) {
      emit(const RaffleSubmitState(
        status: RaffleSubmitStatus.failure,
        error: AppStrings.genericError,
      ));
    }
  }
}
