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

  /// No description provided for @selectRaffleType.
  ///
  /// In en, this message translates to:
  /// **'Select Raffle Type'**
  String get selectRaffleType;

  /// No description provided for @selectSector.
  ///
  /// In en, this message translates to:
  /// **'Select Sector'**
  String get selectSector;

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
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

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

  /// No description provided for @successMessage.
  ///
  /// In en, this message translates to:
  /// **'The raffle was completed successfully.\nPlease check your emails.'**
  String get successMessage;

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

  /// No description provided for @allFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'All fields are required and the email must be valid!'**
  String get allFieldsRequired;

  /// No description provided for @allGiftFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'All fields are required!'**
  String get allGiftFieldsRequired;

  /// No description provided for @emailAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'This email has already been added!'**
  String get emailAlreadyAdded;

  /// No description provided for @minParticipants.
  ///
  /// In en, this message translates to:
  /// **'You must add at least 3 people!'**
  String get minParticipants;

  /// No description provided for @minGifts.
  ///
  /// In en, this message translates to:
  /// **'You must add at least 3 gifts!'**
  String get minGifts;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get genericError;

  /// No description provided for @groupTeam.
  ///
  /// In en, this message translates to:
  /// **'Team-Company'**
  String get groupTeam;

  /// No description provided for @groupFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends-Class'**
  String get groupFriends;

  /// No description provided for @groupFamily.
  ///
  /// In en, this message translates to:
  /// **'Family-Relatives'**
  String get groupFamily;

  /// No description provided for @groupOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get groupOther;

  /// No description provided for @sectorTech.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get sectorTech;

  /// No description provided for @sectorEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get sectorEducation;

  /// No description provided for @sectorFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get sectorFood;

  /// No description provided for @sectorHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get sectorHealth;

  /// No description provided for @sectorSports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sectorSports;

  /// No description provided for @sectorOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get sectorOther;
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
