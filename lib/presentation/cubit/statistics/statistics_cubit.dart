import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/statistics.dart';
import '../../../domain/usecases/get_statistics.dart';

part 'statistics_state.dart';

/// Loads aggregate statistics for the statistics screen.
class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(this._getStatistics) : super(const StatisticsState());

  final GetStatistics _getStatistics;

  Future<void> load() async {
    emit(const StatisticsState(status: StatisticsStatus.loading));
    try {
      final Statistics data = await _getStatistics();
      emit(StatisticsState(status: StatisticsStatus.loaded, data: data));
    } catch (_) {
      // The UI shows a localized generic error for any failure.
      emit(const StatisticsState(status: StatisticsStatus.error));
    }
  }
}
