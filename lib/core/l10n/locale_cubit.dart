import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locales the app ships translations for. The order is also the menu order.
const List<Locale> kSupportedLocales = <Locale>[
  Locale('tr'),
  Locale('en'),
  Locale('ar'),
];

/// Native display names shown in the language picker (always in their own
/// script, regardless of the active locale).
const Map<String, String> kLanguageNames = <String, String>{
  'tr': 'Türkçe',
  'en': 'English',
  'ar': 'العربية',
};

/// Holds the active [Locale] and persists the user's choice.
///
/// On first launch it follows the device language when that language is
/// supported, otherwise falls back to Turkish.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._prefs) : super(_initial(_prefs));

  static const String _key = 'locale_code';

  final SharedPreferences _prefs;

  static Locale _initial(SharedPreferences prefs) {
    final String? saved = prefs.getString(_key);
    if (saved != null && isSupported(saved)) {
      return Locale(saved);
    }
    final String device = PlatformDispatcher.instance.locale.languageCode;
    return isSupported(device) ? Locale(device) : const Locale('tr');
  }

  static bool isSupported(String code) =>
      kSupportedLocales.any((Locale locale) => locale.languageCode == code);

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == state.languageCode) return;
    emit(locale);
    await _prefs.setString(_key, locale.languageCode);
  }
}
