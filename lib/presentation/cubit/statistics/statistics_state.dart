part of 'statistics_cubit.dart';

enum GlobalStatisticsStatus { unavailable, loading, loaded, error }

class StatisticsState extends Equatable {
  const StatisticsState({
    this.local,
    this.global,
    this.globalStatus = GlobalStatisticsStatus.loading,
  });

  /// This device's totals; `null` until loaded.
  final Statistics? local;

  /// Totals across all users once [globalStatus] is loaded.
  final Statistics? global;
  final GlobalStatisticsStatus globalStatus;

  @override
  List<Object?> get props => <Object?>[local, global, globalStatus];
}
