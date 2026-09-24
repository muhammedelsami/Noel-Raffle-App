import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/statistics.dart';
import '../../../domain/usecases/get_global_statistics.dart';
import '../../../domain/usecases/get_statistics.dart';

part 'statistics_state.dart';

/// Loads this device's totals and, when Firebase is configured, the totals
/// across all users.
class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(this._getStatistics, this._getGlobalStatistics)
      : super(const StatisticsState());

  final GetStatistics _getStatistics;
  final GetGlobalStatistics _getGlobalStatistics;

  Future<void> load() async {
    final Statistics local = await _getStatistics();
    if (!_getGlobalStatistics.isAvailable) {
      emit(StatisticsState(
        local: local,
        globalStatus: GlobalStatisticsStatus.unavailable,
      ));
      return;
    }

    emit(StatisticsState(
      local: local,
      globalStatus: GlobalStatisticsStatus.loading,
    ));
    try {
      final Statistics global = await _getGlobalStatistics();
      emit(StatisticsState(
        local: local,
        global: global,
        globalStatus: GlobalStatisticsStatus.loaded,
      ));
    } catch (_) {
      emit(StatisticsState(
        local: local,
        globalStatus: GlobalStatisticsStatus.error,
      ));
    }
  }
}
