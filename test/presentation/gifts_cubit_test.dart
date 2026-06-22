import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/domain/entities/gift.dart';
import 'package:noel_raffle/presentation/cubit/gifts/gifts_cubit.dart';

void main() {
  const Gift g1 = Gift(name: 'Kupa', count: 2);
  const Gift g2 = Gift(name: 'Defter', count: 5);
  const Gift g3 = Gift(name: 'Kalem', count: 9);

  late GiftsCubit cubit;

  setUp(() => cubit = GiftsCubit());
  tearDown(() => cubit.close());

  test('cannot proceed below the minimum', () {
    cubit
      ..add(g1)
      ..add(g2);
    expect(cubit.state.canProceed, isFalse);
  });

  test('canProceed at the minimum count', () {
    cubit
      ..add(g1)
      ..add(g2)
      ..add(g3);
    expect(cubit.state.canProceed, isTrue);
  });

  test('update and removeAt mutate the list', () {
    cubit.add(g1);
    cubit.update(0, g2);
    expect(cubit.state.gifts.single, g2);
    cubit.removeAt(0);
    expect(cubit.state.gifts, isEmpty);
  });
}
