import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/exceptions.dart';
import '../../../domain/entities/shared_result.dart';
import '../../../domain/services/share_code.dart';
import '../../../domain/usecases/lookup_result.dart';

part 'result_lookup_state.dart';

/// Fetches a participant's own result with the code the organizer sent.
class ResultLookupCubit extends Cubit<ResultLookupState> {
  ResultLookupCubit(this._lookupResult) : super(const ResultLookupState());

  final LookupResult _lookupResult;

  Future<void> lookup(String input) async {
    if (state.isLoading) return;
    final String? code = ShareCode.normalize(input);
    if (code == null) {
      emit(const ResultLookupState(status: ResultLookupStatus.invalidCode));
      return;
    }
    emit(const ResultLookupState(status: ResultLookupStatus.loading));
    try {
      final SharedResult result = await _lookupResult(code);
      emit(ResultLookupState(
        status: ResultLookupStatus.found,
        result: result,
      ));
    } on ResultNotFoundException {
      emit(const ResultLookupState(status: ResultLookupStatus.notFound));
    } catch (_) {
      emit(const ResultLookupState(status: ResultLookupStatus.failure));
    }
  }
}
