/// Centralized asset paths so image references are never hard-coded in widgets.
abstract final class AppAssets {
  static const String _images = 'assets/images';

  /// 3D gift box, the new-year raffle artwork.
  static const String giftBox = '$_images/gift-raffle.png';

  /// 3D hand holding a gift, the gift raffle artwork.
  static const String giftHand = '$_images/gift-hand.png';

  /// Every illustration, precached during the splash so screens never pop in.
  static const List<String> illustrations = <String>[giftBox, giftHand];
}
