/// The two raffle flows the app supports. Differences between them (which
/// endpoint to call, whether a gifts step exists, which artwork to show) are
/// driven by this enum so the screens can be shared.
enum RaffleType {
  newYear,
  gift;

  /// Only the gift raffle collects a list of gifts before submitting.
  bool get hasGifts => this == RaffleType.gift;

  bool get isNewYear => this == RaffleType.newYear;
}
