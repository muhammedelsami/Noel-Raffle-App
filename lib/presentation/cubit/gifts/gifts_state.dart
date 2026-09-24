part of 'gifts_cubit.dart';

class GiftsState extends Equatable {
  const GiftsState({this.gifts = const <Gift>[]});

  final List<Gift> gifts;

  /// Enough gifts have been added to start the raffle.
  bool get canProceed => gifts.length >= RaffleRules.minGifts;

  /// Total number of gift items (a gift with count 3 counts as 3).
  int get units => gifts.fold(0, (int sum, Gift gift) => sum + gift.count);

  @override
  List<Object?> get props => <Object?>[gifts];
}
