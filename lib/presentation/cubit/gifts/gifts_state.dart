part of 'gifts_cubit.dart';

class GiftsState extends Equatable {
  const GiftsState({this.gifts = const <Gift>[]});

  final List<Gift> gifts;

  /// Enough gifts have been added to start the raffle.
  bool get canProceed => gifts.length >= AppConstants.minGifts;

  @override
  List<Object?> get props => <Object?>[gifts];
}
