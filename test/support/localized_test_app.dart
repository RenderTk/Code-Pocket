import 'package:code_pocket/l10n/l10n.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:flutter/material.dart';

class LocalizedTestApp extends StatelessWidget {
  const LocalizedTestApp({
    super.key,
    required this.home,
    this.locale = const Locale('en'),
  });

  final Widget home;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      color: theme.colorScheme.surface,
      home: home,
    );
  }
}
