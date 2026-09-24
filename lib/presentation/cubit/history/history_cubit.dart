import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/raffle.dart';
import '../../../domain/usecases/delete_raffle.dart';
import '../../../domain/usecases/get_raffle_history.dart';

part 'history_state.dart';

/// Lists and deletes the raffles saved on this device.
class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._getHistory, this._deleteRaffle)
      : super(const HistoryState());

  final GetRaffleHistory _getHistory;
  final DeleteRaffle _deleteRaffle;

  Future<void> load() async {
    try {
      final List<Raffle> raffles = await _getHistory();
      emit(HistoryState(status: HistoryStatus.loaded, raffles: raffles));
    } catch (_) {
      emit(const HistoryState(status: HistoryStatus.error));
    }
  }

  Future<void> delete(Raffle raffle) async {
    // Remove it from the list right away; deleting online codes can be slow.
    emit(HistoryState(
      status: HistoryStatus.loaded,
      raffles: state.raffles.where((Raffle r) => r.id != raffle.id).toList(),
    ));
    try {
      await _deleteRaffle(raffle);
    } catch (_) {
      // Reloading below brings the raffle back if it could not be deleted.
    }
    await load();
  }
}
