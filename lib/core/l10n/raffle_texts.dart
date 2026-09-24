import 'package:intl/intl.dart';

import '../../domain/entities/draw_assignment.dart';
import '../../domain/entities/raffle.dart';
import '../../domain/entities/raffle_rules.dart';
import '../../domain/entities/raffle_type.dart';
import '../../domain/services/share_code.dart';
import '../../l10n/app_localizations.dart';
import '../constants/app_constants.dart';

/// Localized name of a raffle type.
String raffleTypeLabel(AppLocalizations l10n, RaffleType type) =>
    switch (type) {
      RaffleType.newYear => l10n.newYearRaffle,
      RaffleType.gift => l10n.giftRaffle,
    };

/// Localized explanation of why a raffle cannot be drawn yet.
String ruleViolationMessage(
  AppLocalizations l10n,
  RaffleRuleViolation violation,
) =>
    switch (violation) {
      RaffleRuleViolation.notEnoughParticipants =>
        l10n.minParticipants(RaffleRules.minParticipants),
      RaffleRuleViolation.notEnoughGifts => l10n.minGifts(RaffleRules.minGifts),
      RaffleRuleViolation.tooManyGifts => l10n.tooManyGifts,
      RaffleRuleViolation.noValidMatch => l10n.noValidMatch,
    };

/// The private message sent to one participant.
///
/// Once the raffle is published it carries only the personal code, so the
/// result stays hidden from whoever sends it; before that it carries the
/// result itself.
String participantMessage(
  AppLocalizations l10n,
  Raffle raffle,
  DrawAssignment assignment,
) {
  final String name = assignment.participant.name;
  final String? code = assignment.code;
  final String? match = assignment.match;
  final String body;
  if (code != null) {
    body = l10n.shareCodeMessage(
      raffle.title,
      name,
      ShareCode.format(code),
      AppConstants.playStoreUrl,
    );
  } else if (raffle.type.isNewYear) {
    body = _withWish(
      l10n,
      l10n.shareSecretSantaMessage(raffle.title, name, match ?? ''),
      raffle.wishOf(match),
    );
  } else if (match != null) {
    body = l10n.shareGiftMessage(raffle.title, name, match);
  } else {
    body = l10n.shareNoPrizeMessage(raffle.title, name);
  }
  return _withNote(l10n, body, raffle.note);
}

/// Every result in one message; only used for gift raffles, whose results are
/// not secret.
String allResultsMessage(AppLocalizations l10n, Raffle raffle) {
  final String lines = raffle.assignments
      .map(
        (DrawAssignment a) =>
            '${a.participant.name}: ${a.match ?? l10n.noPrizeShort}',
      )
      .join('\n');
  return _withNote(
    l10n,
    '${l10n.shareAllTitle(raffle.title)}\n\n$lines',
    raffle.note,
  );
}

String _withNote(AppLocalizations l10n, String body, String note) =>
    note.isEmpty ? body : '$body\n\n${l10n.shareNoteLine(note)}';

String _withWish(AppLocalizations l10n, String body, String? wish) =>
    wish == null || wish.isEmpty
        ? body
        : '$body\n${l10n.shareWishLine(wish)}';

/// When [raffle] was drawn, e.g. "Dec 24, 2026 19:30".
String raffleDate(AppLocalizations l10n, Raffle raffle) =>
    DateFormat.yMMMd(l10n.localeName).add_Hm().format(raffle.createdAt);

/// One-line description of a drawn raffle: date and participant count.
String raffleSummary(AppLocalizations l10n, Raffle raffle) =>
    '${raffleDate(l10n, raffle)} • '
    '${l10n.participantCount(raffle.assignments.length)}';
