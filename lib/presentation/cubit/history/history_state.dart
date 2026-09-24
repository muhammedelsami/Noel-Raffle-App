part of 'history_cubit.dart';

enum HistoryStatus { loading, loaded, error }

class HistoryState extends Equatable {
  const HistoryState({
    this.status = HistoryStatus.loading,
    this.raffles = const <Raffle>[],
  });

  final HistoryStatus status;

  /// Saved raffles, newest first.
  final List<Raffle> raffles;

  @override
  List<Object?> get props => <Object?>[status, raffles];
}
