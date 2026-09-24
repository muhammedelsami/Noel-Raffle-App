import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/core/error/exceptions.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:noel_raffle/domain/entities/shared_result.dart';
import 'package:noel_raffle/domain/entities/statistics.dart';
import 'package:noel_raffle/domain/repositories/online_raffle_repository.dart';
import 'package:noel_raffle/domain/usecases/lookup_result.dart';
import 'package:noel_raffle/presentation/cubit/result_lookup/result_lookup_cubit.dart';

const SharedResult ayse = SharedResult(
  title: 'Ofis',
  type: RaffleType.newYear,
  participantName: 'Ayşe',
  match: 'Burak',
);

/// Serves [ayse] for code ABCDEFGH, fails for FAILFAIL, and reports
/// everything else as not found.
class FakeOnline implements OnlineRaffleRepository {
  String? lastCode;

  @override
  bool get isAvailable => true;

  @override
  Future<SharedResult> lookup(String code) async {
    lastCode = code;
    if (code == 'ABCDEFGH') return ayse;
    if (code == 'FAHLFAHL') throw const CloudException('offline');
    throw const ResultNotFoundException();
  }

  @override
  Future<Raffle> publish(Raffle raffle) => throw UnimplementedError();

  @override
  Future<void> unpublish(Raffle raffle) => throw UnimplementedError();

  @override
  Future<void> recordStatistics(Raffle raffle) => throw UnimplementedError();

  @override
  Future<Statistics> fetchGlobalStatistics() => throw UnimplementedError();
}

void main() {
  late FakeOnline online;

  ResultLookupCubit build() {
    online = FakeOnline();
    return ResultLookupCubit(LookupResult(online));
  }

  blocTest<ResultLookupCubit, ResultLookupState>(
    'normalizes the code and shows the result',
    build: build,
    act: (ResultLookupCubit cubit) => cubit.lookup(' abcd-efgh '),
    expect: () => const <ResultLookupState>[
      ResultLookupState(status: ResultLookupStatus.loading),
      ResultLookupState(status: ResultLookupStatus.found, result: ayse),
    ],
    verify: (_) => expect(online.lastCode, 'ABCDEFGH'),
  );

  blocTest<ResultLookupCubit, ResultLookupState>(
    'rejects malformed codes without a network call',
    build: build,
    act: (ResultLookupCubit cubit) => cubit.lookup('abc'),
    expect: () => const <ResultLookupState>[
      ResultLookupState(status: ResultLookupStatus.invalidCode),
    ],
    verify: (_) => expect(online.lastCode, isNull),
  );

  blocTest<ResultLookupCubit, ResultLookupState>(
    'reports unknown codes',
    build: build,
    act: (ResultLookupCubit cubit) => cubit.lookup('ZZZZZZZZ'),
    expect: () => const <ResultLookupState>[
      ResultLookupState(status: ResultLookupStatus.loading),
      ResultLookupState(status: ResultLookupStatus.notFound),
    ],
  );

  blocTest<ResultLookupCubit, ResultLookupState>(
    'reports connection failures',
    build: build,
    act: (ResultLookupCubit cubit) => cubit.lookup('FAHL-FAHL'),
    expect: () => const <ResultLookupState>[
      ResultLookupState(status: ResultLookupStatus.loading),
      ResultLookupState(status: ResultLookupStatus.failure),
    ],
  );
}
