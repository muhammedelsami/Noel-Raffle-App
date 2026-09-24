import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/domain/entities/draw_assignment.dart';
import 'package:noel_raffle/domain/entities/match_exclusion.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/entities/raffle_config.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:noel_raffle/domain/repositories/raffle_history_repository.dart';
import 'package:noel_raffle/domain/usecases/get_raffle_history.dart';
import 'package:noel_raffle/presentation/cubit/participants/participants_cubit.dart';

void main() {
  const Participant a = Participant(name: 'Ayşe', email: 'a@x.com');
  const Participant b = Participant(name: 'Burak');
  const Participant c = Participant(name: 'Cem');

  late ParticipantsCubit cubit;

  setUp(() => cubit = ParticipantsCubit());
  tearDown(() => cubit.close());

  test('starts empty and cannot proceed', () {
    expect(cubit.state.participants, isEmpty);
    expect(cubit.state.canProceed, isFalse);
  });

  test('canProceed becomes true at the minimum count', () {
    cubit
      ..add(a)
      ..add(b)
      ..add(c);
    expect(cubit.state.participants.length, 3);
    expect(cubit.state.canProceed, isTrue);
  });

  test('update replaces the participant at an index', () {
    cubit.add(a);
    cubit.update(0, b);
    expect(cubit.state.participants.single, b);
  });

  test('removeAt drops the participant', () {
    cubit
      ..add(a)
      ..add(b);
    cubit.removeAt(0);
    expect(cubit.state.participants.single, b);
  });

  test('nameExists is case-insensitive, trims and respects exclusion', () {
    cubit.add(b);
    expect(cubit.nameExists('BURAK'), isTrue);
    expect(cubit.nameExists('  burak '), isTrue);
    expect(cubit.nameExists('Burak', excludingIndex: 0), isFalse);
    expect(cubit.nameExists('Cem'), isFalse);
  });

  group('matching rules', () {
    const MatchExclusion rule = MatchExclusion('Ayşe', 'Burak');

    setUp(() {
      cubit
        ..add(a)
        ..add(b)
        ..add(c);
    });

    test('adds a rule once and never for the same person twice', () {
      cubit
        ..addExclusion(rule)
        ..addExclusion(const MatchExclusion('burak', 'ayşe'))
        ..addExclusion(const MatchExclusion('Cem', 'cem'));
      expect(cubit.state.exclusions, <MatchExclusion>[rule]);
    });

    test('follows a renamed participant', () {
      cubit
        ..addExclusion(rule)
        ..update(0, const Participant(name: 'Ayşe Nur'));
      expect(cubit.state.exclusions.single,
          const MatchExclusion('Ayşe Nur', 'Burak'));
    });

    test('drops the rules of a removed participant', () {
      cubit
        ..addExclusion(rule)
        ..removeAt(1);
      expect(cubit.state.exclusions, isEmpty);
    });

    test('passes the rules to the draw constraints', () {
      cubit.addExclusion(rule);
      expect(cubit.state.constraints.allows('Ayşe', 'Burak'), isFalse);
      expect(cubit.state.constraints.allows('Ayşe', 'Cem'), isTrue);
    });
  });

  test('finds last time\'s raffle of the group and avoids its pairs', () async {
    final Raffle lastYear = Raffle(
      id: 'last',
      config: const RaffleConfig(title: 'Ofis', type: RaffleType.newYear),
      createdAt: DateTime.utc(2025, 12, 31),
      assignments: const <DrawAssignment>[
        DrawAssignment(participant: Participant(name: 'Ayşe'), match: 'Cem'),
        DrawAssignment(participant: Participant(name: 'Cem'), match: 'Burak'),
        DrawAssignment(participant: Participant(name: 'Burak'), match: 'Ayşe'),
      ],
    );
    final ParticipantsCubit withHistory = ParticipantsCubit(
      participants: const <Participant>[a, b, c],
      history: GetRaffleHistory(_FakeHistory(<Raffle>[lastYear])),
    );
    addTearDown(withHistory.close);
    await Future<void>.delayed(Duration.zero);

    expect(withHistory.state.previousRaffle, lastYear);
    expect(withHistory.state.constraints.allows('Ayşe', 'Cem'), isFalse);
    withHistory.setAvoidPrevious(false);
    expect(withHistory.state.constraints.allows('Ayşe', 'Cem'), isTrue);
  });
}

class _FakeHistory implements RaffleHistoryRepository {
  _FakeHistory(this._raffles);

  final List<Raffle> _raffles;

  @override
  Future<List<Raffle>> getAll() async => _raffles;

  @override
  Future<void> save(Raffle raffle) async {}

  @override
  Future<void> delete(String id) async {}
}
