part of 'statistics_cubit.dart';

enum StatisticsStatus { loading, loaded, error }

class StatisticsState extends Equatable {
  const StatisticsState({
    this.status = StatisticsStatus.loading,
    this.data,
    this.error,
  });

  final StatisticsStatus status;
  final Statistics? data;
  final String? error;

  @override
  List<Object?> get props => <Object?>[status, data, error];
}
