import 'package:flutter/material.dart';

import '../../domain/entities/raffle_type.dart';
import '../constants/app_assets.dart';

/// Accent colors of one raffle type, taken from the active [ColorScheme].
typedef AccentColors = ({Color accent, Color container, Color onContainer});

/// How each [RaffleType] looks. The domain enum stays free of Flutter, so the
/// visuals live in this presentation-side extension.
extension RaffleTypeStyle on RaffleType {
  IconData get icon => switch (this) {
        RaffleType.newYear => Icons.ac_unit_rounded,
        RaffleType.gift => Icons.card_giftcard_rounded,
      };

  String get illustration => switch (this) {
        RaffleType.newYear => AppAssets.giftBox,
        RaffleType.gift => AppAssets.giftHand,
      };

  AccentColors accentColors(ColorScheme scheme) => switch (this) {
        RaffleType.newYear => (
            accent: scheme.primary,
            container: scheme.primaryContainer,
            onContainer: scheme.onPrimaryContainer,
          ),
        RaffleType.gift => (
            accent: scheme.secondary,
            container: scheme.secondaryContainer,
            onContainer: scheme.onSecondaryContainer,
          ),
      };

  /// Number of steps in the creation flow: details, participants and, for a
  /// gift raffle, gifts.
  int get stepCount => hasGifts ? 3 : 2;
}
