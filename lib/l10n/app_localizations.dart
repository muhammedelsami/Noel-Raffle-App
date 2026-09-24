import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Noel Raffle'**
  String get appName;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Gift Raffle'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a raffle type'**
  String get homeSubtitle;

  /// No description provided for @newYearRaffle.
  ///
  /// In en, this message translates to:
  /// **'New Year Raffle'**
  String get newYearRaffle;

  /// No description provided for @giftRaffle.
  ///
  /// In en, this message translates to:
  /// **'Gift Raffle'**
  String get giftRaffle;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Our Statistics'**
  String get statistics;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get about;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Our Website'**
  String get website;

  /// No description provided for @contribute.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contribute;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @raffleTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Raffle Title*'**
  String get raffleTitleHint;

  /// No description provided for @createNewYearRaffle.
  ///
  /// In en, this message translates to:
  /// **'Create New Year Raffle'**
  String get createNewYearRaffle;

  /// No description provided for @createGiftRaffle.
  ///
  /// In en, this message translates to:
  /// **'Create Gift Raffle'**
  String get createGiftRaffle;

  /// No description provided for @addParticipant.
  ///
  /// In en, this message translates to:
  /// **'Add New Participant'**
  String get addParticipant;

  /// No description provided for @newParticipant.
  ///
  /// In en, this message translates to:
  /// **'New Participant'**
  String get newParticipant;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get name;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get next;

  /// No description provided for @addGift.
  ///
  /// In en, this message translates to:
  /// **'Add New Gift'**
  String get addGift;

  /// No description provided for @giftName.
  ///
  /// In en, this message translates to:
  /// **'Gift Name'**
  String get giftName;

  /// No description provided for @giftCount.
  ///
  /// In en, this message translates to:
  /// **'Gift Count'**
  String get giftCount;

  /// No description provided for @startRaffle.
  ///
  /// In en, this message translates to:
  /// **'Start Raffle'**
  String get startRaffle;

  /// No description provided for @statTotalRaffle.
  ///
  /// In en, this message translates to:
  /// **'Raffles'**
  String get statTotalRaffle;

  /// No description provided for @statNewYearRaffle.
  ///
  /// In en, this message translates to:
  /// **'New Year Raffle'**
  String get statNewYearRaffle;

  /// No description provided for @statGiftRaffle.
  ///
  /// In en, this message translates to:
  /// **'Gift Raffle'**
  String get statGiftRaffle;

  /// No description provided for @statGiftCount.
  ///
  /// In en, this message translates to:
  /// **'Gift Count'**
  String get statGiftCount;

  /// No description provided for @statParticipantCount.
  ///
  /// In en, this message translates to:
  /// **'Participant Count'**
  String get statParticipantCount;

  /// No description provided for @aboutText.
  ///
  /// In en, this message translates to:
  /// **'A new year is a fresh start. It is time to leave the past behind and step into a tomorrow full of new hopes. Look ahead with hope, discover the beauties of life and share them with your loved ones. May the new year bring you happiness, health and success! 🌟 🎉'**
  String get aboutText;

  /// No description provided for @mobileDevelopers.
  ///
  /// In en, this message translates to:
  /// **'Mobile Developers'**
  String get mobileDevelopers;

  /// No description provided for @backendDevelopers.
  ///
  /// In en, this message translates to:
  /// **'BackEnd Developers'**
  String get backendDevelopers;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @enterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter the raffle title.'**
  String get enterTitle;

  /// No description provided for @allGiftFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'All fields are required!'**
  String get allGiftFieldsRequired;

  /// No description provided for @minParticipants.
  ///
  /// In en, this message translates to:
  /// **'You must add at least {count} people!'**
  String minParticipants(int count);

  /// No description provided for @minGifts.
  ///
  /// In en, this message translates to:
  /// **'You must add at least {count, plural, =1{1 gift} other{{count} gifts}}!'**
  String minGifts(int count);

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get genericError;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'Past Raffles'**
  String get history;

  /// No description provided for @viewMyResult.
  ///
  /// In en, this message translates to:
  /// **'View My Result'**
  String get viewMyResult;

  /// No description provided for @raffleNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Note for participants (optional)'**
  String get raffleNoteHint;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptional;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name.'**
  String get nameRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email address is not valid.'**
  String get invalidEmail;

  /// No description provided for @nameAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'This name has already been added!'**
  String get nameAlreadyAdded;

  /// No description provided for @tooManyGifts.
  ///
  /// In en, this message translates to:
  /// **'There can\'t be more gifts than participants.'**
  String get tooManyGifts;

  /// No description provided for @statsThisDevice.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get statsThisDevice;

  /// No description provided for @statsAllUsers.
  ///
  /// In en, this message translates to:
  /// **'All users'**
  String get statsAllUsers;

  /// No description provided for @globalStatsError.
  ///
  /// In en, this message translates to:
  /// **'Global statistics are unavailable right now.'**
  String get globalStatsError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get retry;

  /// No description provided for @resultSecretInfo.
  ///
  /// In en, this message translates to:
  /// **'Results are secret! Pass the phone around; each person taps their own name to see who they\'re buying a gift for.'**
  String get resultSecretInfo;

  /// No description provided for @resultGiftInfo.
  ///
  /// In en, this message translates to:
  /// **'The raffle is done! Here are the winners.'**
  String get resultGiftInfo;

  /// No description provided for @tapToReveal.
  ///
  /// In en, this message translates to:
  /// **'Tap to reveal'**
  String get tapToReveal;

  /// No description provided for @seen.
  ///
  /// In en, this message translates to:
  /// **'Seen'**
  String get seen;

  /// No description provided for @revealTitle.
  ///
  /// In en, this message translates to:
  /// **'Only {name} should look!'**
  String revealTitle(String name);

  /// No description provided for @revealBody.
  ///
  /// In en, this message translates to:
  /// **'Hand the phone to {name} now. Tap \"Reveal\" when ready.'**
  String revealBody(String name);

  /// No description provided for @reveal.
  ///
  /// In en, this message translates to:
  /// **'Reveal'**
  String get reveal;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}!'**
  String greeting(String name);

  /// No description provided for @yourGiftee.
  ///
  /// In en, this message translates to:
  /// **'You\'re buying a gift for'**
  String get yourGiftee;

  /// No description provided for @yourPrize.
  ///
  /// In en, this message translates to:
  /// **'Your prize'**
  String get yourPrize;

  /// No description provided for @noPrize.
  ///
  /// In en, this message translates to:
  /// **'No prize this time. Better luck next time!'**
  String get noPrize;

  /// No description provided for @noPrizeShort.
  ///
  /// In en, this message translates to:
  /// **'No prize'**
  String get noPrizeShort;

  /// No description provided for @shareResults.
  ///
  /// In en, this message translates to:
  /// **'Share Results'**
  String get shareResults;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @sendByEmail.
  ///
  /// In en, this message translates to:
  /// **'Send by email'**
  String get sendByEmail;

  /// No description provided for @publishOnline.
  ///
  /// In en, this message translates to:
  /// **'Create Online Codes'**
  String get publishOnline;

  /// No description provided for @publishInfo.
  ///
  /// In en, this message translates to:
  /// **'A personal code is created for each participant. Participants enter it under \"View My Result\" in the Noel Raffle app and see only their own result.'**
  String get publishInfo;

  /// No description provided for @codesReady.
  ///
  /// In en, this message translates to:
  /// **'Online codes are ready. Use the share icon to send each participant their own code.'**
  String get codesReady;

  /// No description provided for @publishFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the codes. Check your internet connection and try again.'**
  String get publishFailed;

  /// No description provided for @codeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code: {code}'**
  String codeLabel(String code);

  /// No description provided for @shareSecretSantaMessage.
  ///
  /// In en, this message translates to:
  /// **'🎄 {title}\nHi {name}! In the New Year raffle you\'re buying a gift for: {match}'**
  String shareSecretSantaMessage(String title, String name, String match);

  /// No description provided for @shareGiftMessage.
  ///
  /// In en, this message translates to:
  /// **'🎁 {title}\nHi {name}! Your prize in the raffle: {match}'**
  String shareGiftMessage(String title, String name, String match);

  /// No description provided for @shareNoPrizeMessage.
  ///
  /// In en, this message translates to:
  /// **'🎁 {title}\nHi {name}! No prize this time. Better luck next time!'**
  String shareNoPrizeMessage(String title, String name);

  /// No description provided for @shareCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'🎄 {title}\nHi {name}! To see your raffle result, open the Noel Raffle app and enter this code under \"View My Result\": {code}\n\nApp: {url}'**
  String shareCodeMessage(String title, String name, String code, String url);

  /// No description provided for @shareNoteLine.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String shareNoteLine(String note);

  /// No description provided for @shareAllTitle.
  ///
  /// In en, this message translates to:
  /// **'🎁 {title} — Results'**
  String shareAllTitle(String title);

  /// No description provided for @emailSubject.
  ///
  /// In en, this message translates to:
  /// **'{title} — Your raffle result'**
  String emailSubject(String title);

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t run any raffles yet.'**
  String get historyEmpty;

  /// No description provided for @deleteRaffleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this raffle from history?'**
  String get deleteRaffleConfirm;

  /// No description provided for @deleteRaffleCodesNote.
  ///
  /// In en, this message translates to:
  /// **'The online codes sent to participants will stop working too.'**
  String get deleteRaffleCodesNote;

  /// No description provided for @participantCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 participant} other{{count} participants}}'**
  String participantCount(int count);

  /// No description provided for @lookupInfo.
  ///
  /// In en, this message translates to:
  /// **'Enter the code the organizer sent you.'**
  String get lookupInfo;

  /// No description provided for @codeHint.
  ///
  /// In en, this message translates to:
  /// **'Code (e.g. ABCD-EFGH)'**
  String get codeHint;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'The code must be 8 characters (e.g. ABCD-EFGH).'**
  String get invalidCode;

  /// No description provided for @resultNotFound.
  ///
  /// In en, this message translates to:
  /// **'No result was found for this code.'**
  String get resultNotFound;

  /// No description provided for @lookupFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get the result. Check your internet connection and try again.'**
  String get lookupFailed;

  /// No description provided for @showResult.
  ///
  /// In en, this message translates to:
  /// **'Show Result'**
  String get showResult;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
