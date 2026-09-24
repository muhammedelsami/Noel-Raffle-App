import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/domain/entities/gift.dart';
import 'package:noel_raffle/presentation/cubit/gifts/gifts_cubit.dart';

void main() {
  const Gift g1 = Gift(name: 'Kupa', count: 2);
  const Gift g2 = Gift(name: 'Defter', count: 5);

  late GiftsCubit cubit;

  setUp(() => cubit = GiftsCubit());
  tearDown(() => cubit.close());

  test('cannot proceed without gifts', () {
    expect(cubit.state.canProceed, isFalse);
  });

  test('canProceed once a gift is added', () {
    cubit.add(g1);
    expect(cubit.state.canProceed, isTrue);
  });

  test('update and removeAt mutate the list', () {
    cubit.add(g1);
    cubit.update(0, g2);
    expect(cubit.state.gifts.single, g2);
    cubit.removeAt(0);
    expect(cubit.state.gifts, isEmpty);
  });

  test('insert puts a removed gift back where it was', () {
    cubit
      ..add(g1)
      ..add(g2);
    final Gift removed = cubit.removeAt(0);
    cubit.insert(0, removed);
    expect(cubit.state.gifts, <Gift>[g1, g2]);
  });

  test('starts with the given gifts', () {
    final GiftsCubit prefilled = GiftsCubit(gifts: const <Gift>[g1]);
    addTearDown(prefilled.close);
    expect(prefilled.state.gifts, <Gift>[g1]);
  });
}
