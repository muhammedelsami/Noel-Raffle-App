import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// Shorthand for `AppLocalizations.of(context)` so screens can read localized
/// strings with `context.l10n.someKey`.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
