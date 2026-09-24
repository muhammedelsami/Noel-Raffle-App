import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/gift.dart';
import '../../../domain/entities/raffle_rules.dart';

part 'gifts_state.dart';

/// Manages the in-memory gift list for a gift raffle.
class GiftsCubit extends Cubit<GiftsState> {
  GiftsCubit({List<Gift> gifts = const <Gift>[]})
      : super(GiftsState(gifts: gifts));

  void add(Gift gift) {
    emit(GiftsState(gifts: <Gift>[...state.gifts, gift]));
  }

  void update(int index, Gift gift) {
    final List<Gift> list = <Gift>[...state.gifts];
    list[index] = gift;
    emit(GiftsState(gifts: list));
  }

  /// Removes the gift at [index] and returns it, so [insert] can undo it.
  Gift removeAt(int index) {
    final Gift gift = state.gifts[index];
    emit(GiftsState(gifts: <Gift>[...state.gifts]..removeAt(index)));
    return gift;
  }

  void insert(int index, Gift gift) {
    emit(GiftsState(
      gifts: <Gift>[...state.gifts]
        ..insert(index.clamp(0, state.gifts.length), gift),
    ));
  }
}
