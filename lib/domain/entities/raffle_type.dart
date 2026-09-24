/// The two raffle flows the app supports. Differences between them (how the
/// draw works, whether a gifts step exists, which artwork to show) are driven
/// by this enum so the screens can be shared.
enum RaffleType {
  /// Secret-Santa style: every participant buys a gift for another one.
  newYear,

  /// Prize draw: the listed gifts are handed out to random participants.
  gift;

  /// Only the gift raffle collects a list of gifts before drawing.
  bool get hasGifts => this == RaffleType.gift;

  bool get isNewYear => this == RaffleType.newYear;

  /// Parses a persisted [name], falling back to [newYear] for unknown input.
  static RaffleType fromName(String? name) => RaffleType.values.firstWhere(
        (RaffleType type) => type.name == name,
        orElse: () => RaffleType.newYear,
      );
}
