import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
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
}
