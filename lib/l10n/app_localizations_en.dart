// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Noel Raffle';

  @override
  String get homeTitle => 'Gift Raffle';

  @override
  String get homeSubtitle => 'Choose a raffle type';

  @override
  String get newYearRaffle => 'New Year Raffle';

  @override
  String get giftRaffle => 'Gift Raffle';

  @override
  String get statistics => 'Our Statistics';

  @override
  String get about => 'About Us';

  @override
  String get rateUs => 'Rate Us';

  @override
  String get website => 'Our Website';

  @override
  String get contribute => 'Contribute';

  @override
  String get close => 'Close';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get raffleTitleHint => 'Enter Raffle Title*';

  @override
  String get createNewYearRaffle => 'Create New Year Raffle';

  @override
  String get createGiftRaffle => 'Create Gift Raffle';

  @override
  String get addParticipant => 'Add New Participant';

  @override
  String get newParticipant => 'New Participant';

  @override
  String get name => 'Full name';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get next => 'Continue';

  @override
  String get addGift => 'Add New Gift';

  @override
  String get giftName => 'Gift Name';

  @override
  String get giftCount => 'Gift Count';

  @override
  String get startRaffle => 'Start Raffle';

  @override
  String get statTotalRaffle => 'Raffles';

  @override
  String get statNewYearRaffle => 'New Year Raffle';

  @override
  String get statGiftRaffle => 'Gift Raffle';

  @override
  String get statGiftCount => 'Gift Count';

  @override
  String get statParticipantCount => 'Participant Count';

  @override
  String get aboutText =>
      'A new year is a fresh start. It is time to leave the past behind and step into a tomorrow full of new hopes. Look ahead with hope, discover the beauties of life and share them with your loved ones. May the new year bring you happiness, health and success! 🌟 🎉';

  @override
  String get mobileDevelopers => 'Mobile Developers';

  @override
  String get backendDevelopers => 'BackEnd Developers';

  @override
  String get warning => 'Warning';

  @override
  String get ok => 'OK';

  @override
  String get enterTitle => 'Please enter the raffle title.';

  @override
  String get allGiftFieldsRequired => 'All fields are required!';

  @override
  String minParticipants(int count) {
    return 'You must add at least $count people!';
  }

  @override
  String minGifts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gifts',
      one: '1 gift',
    );
    return 'You must add at least $_temp0!';
  }

  @override
  String get genericError => 'An error occurred. Please try again.';

  @override
  String get history => 'Past Raffles';

  @override
  String get viewMyResult => 'View My Result';

  @override
  String get raffleNoteHint => 'Note for participants (optional)';

  @override
  String get emailOptional => 'Email (optional)';

  @override
  String get nameRequired => 'Please enter a name.';

  @override
  String get invalidEmail => 'The email address is not valid.';

  @override
  String get nameAlreadyAdded => 'This name has already been added!';

  @override
  String get tooManyGifts => 'There can\'t be more gifts than participants.';

  @override
  String get statsThisDevice => 'On this device';

  @override
  String get statsAllUsers => 'All users';

  @override
  String get globalStatsError => 'Global statistics are unavailable right now.';

  @override
  String get retry => 'Try Again';

  @override
  String get resultSecretInfo =>
      'Results are secret! Pass the phone around; each person taps their own name to see who they\'re buying a gift for.';

  @override
  String get resultGiftInfo => 'The raffle is done! Here are the winners.';

  @override
  String get tapToReveal => 'Tap to reveal';

  @override
  String get seen => 'Seen';

  @override
  String revealTitle(String name) {
    return 'Only $name should look!';
  }

  @override
  String revealBody(String name) {
    return 'Hand the phone to $name now. Tap \"Reveal\" when ready.';
  }

  @override
  String get reveal => 'Reveal';

  @override
  String get hide => 'Hide';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String greeting(String name) {
    return 'Hi $name!';
  }

  @override
  String get yourGiftee => 'You\'re buying a gift for';

  @override
  String get yourPrize => 'Your prize';

  @override
  String get noPrize => 'No prize this time. Better luck next time!';

  @override
  String get noPrizeShort => 'No prize';

  @override
  String get shareResults => 'Share Results';

  @override
  String get share => 'Share';

  @override
  String get sendByEmail => 'Send by email';

  @override
  String get publishOnline => 'Create Online Codes';

  @override
  String get publishInfo =>
      'A personal code is created for each participant. Participants enter it under \"View My Result\" in the Noel Raffle app and see only their own result.';

  @override
  String get codesReady =>
      'Online codes are ready. Use the share icon to send each participant their own code.';

  @override
  String get publishFailed =>
      'Couldn\'t create the codes. Check your internet connection and try again.';

  @override
  String codeLabel(String code) {
    return 'Code: $code';
  }

  @override
  String shareSecretSantaMessage(String title, String name, String match) {
    return '🎄 $title\nHi $name! In the New Year raffle you\'re buying a gift for: $match';
  }

  @override
  String shareGiftMessage(String title, String name, String match) {
    return '🎁 $title\nHi $name! Your prize in the raffle: $match';
  }

  @override
  String shareNoPrizeMessage(String title, String name) {
    return '🎁 $title\nHi $name! No prize this time. Better luck next time!';
  }

  @override
  String shareCodeMessage(String title, String name, String code, String url) {
    return '🎄 $title\nHi $name! To see your raffle result, open the Noel Raffle app and enter this code under \"View My Result\": $code\n\nApp: $url';
  }

  @override
  String shareNoteLine(String note) {
    return 'Note: $note';
  }

  @override
  String shareAllTitle(String title) {
    return '🎁 $title — Results';
  }

  @override
  String emailSubject(String title) {
    return '$title — Your raffle result';
  }

  @override
  String get historyEmpty => 'You haven\'t run any raffles yet.';

  @override
  String get deleteRaffleConfirm => 'Delete this raffle from history?';

  @override
  String get deleteRaffleCodesNote =>
      'The online codes sent to participants will stop working too.';

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participants',
      one: '1 participant',
    );
    return '$_temp0';
  }

  @override
  String get lookupInfo => 'Enter the code the organizer sent you.';

  @override
  String get codeHint => 'Code (e.g. ABCD-EFGH)';

  @override
  String get invalidCode => 'The code must be 8 characters (e.g. ABCD-EFGH).';

  @override
  String get resultNotFound => 'No result was found for this code.';

  @override
  String get lookupFailed =>
      'Couldn\'t get the result. Check your internet connection and try again.';

  @override
  String get showResult => 'Show Result';
}
