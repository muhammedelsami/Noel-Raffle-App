import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/presentation/cubit/participants/participants_cubit.dart';

void main() {
  const Participant a = Participant(name: 'A', surname: 'A', email: 'a@x.com');
  const Participant b = Participant(name: 'B', surname: 'B', email: 'b@x.com');
  const Participant c = Participant(name: 'C', surname: 'C', email: 'c@x.com');

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

  test('emailExists is case-insensitive and respects exclusion', () {
    cubit.add(a);
    expect(cubit.emailExists('A@X.COM'), isTrue);
    expect(cubit.emailExists('a@x.com', excludingIndex: 0), isFalse);
    expect(cubit.emailExists('missing@x.com'), isFalse);
  });
}
