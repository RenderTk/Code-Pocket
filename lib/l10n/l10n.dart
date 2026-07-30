import 'package:code_pocket/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

export 'package:code_pocket/l10n/generated/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
