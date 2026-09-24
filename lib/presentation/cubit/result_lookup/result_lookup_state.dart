part of 'result_lookup_cubit.dart';

enum ResultLookupStatus {
  initial,
  invalidCode,
  loading,
  found,
  notFound,
  failure,
}

class ResultLookupState extends Equatable {
  const ResultLookupState({
    this.status = ResultLookupStatus.initial,
    this.result,
  });

  final ResultLookupStatus status;

  /// The fetched result once [status] is found.
  final SharedResult? result;

  bool get isLoading => status == ResultLookupStatus.loading;

  @override
  List<Object?> get props => <Object?>[status, result];
}
