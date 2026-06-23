import '../../l10n/app_localizations.dart';

/// Localized label for a group backend code (see `AppConstants.groupCodes`).
String groupLabel(AppLocalizations l10n, int code) => switch (code) {
      10 => l10n.groupTeam,
      20 => l10n.groupFriends,
      30 => l10n.groupFamily,
      _ => l10n.groupOther,
    };

/// Localized label for a sector backend code (see `AppConstants.sectorCodes`).
String sectorLabel(AppLocalizations l10n, int code) => switch (code) {
      10 => l10n.sectorTech,
      20 => l10n.sectorEducation,
      30 => l10n.sectorFood,
      40 => l10n.sectorHealth,
      50 => l10n.sectorSports,
      _ => l10n.sectorOther,
    };
