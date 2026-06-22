import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/gift.dart';

part 'gifts_state.dart';

/// Manages the in-memory gift list for a gift raffle.
class GiftsCubit extends Cubit<GiftsState> {
  GiftsCubit() : super(const GiftsState());

  void add(Gift gift) {
    emit(GiftsState(gifts: <Gift>[...state.gifts, gift]));
  }

  void update(int index, Gift gift) {
    final List<Gift> list = <Gift>[...state.gifts];
    list[index] = gift;
    emit(GiftsState(gifts: list));
  }

  void removeAt(int index) {
    final List<Gift> list = <Gift>[...state.gifts]..removeAt(index);
    emit(GiftsState(gifts: list));
  }
}
