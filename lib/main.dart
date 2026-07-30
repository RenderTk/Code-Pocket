import 'package:code_pocket/l10n/l10n.dart';
import 'package:code_pocket/screens/home_screen/home_screen.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Locale resolveAppLocale(
  List<Locale>? preferredLocales,
  Iterable<Locale> supportedLocales,
) {
  for (final preferredLocale in preferredLocales ?? const <Locale>[]) {
    for (final supportedLocale in supportedLocales) {
      if (preferredLocale.languageCode == supportedLocale.languageCode) {
        return supportedLocale;
      }
    }
  }
  return const Locale('en');
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appName,
      color: theme.colorScheme.surface,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      themeAnimationDuration: AppDurations.standard,
      themeAnimationCurve: Curves.easeOutCubic,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: resolveAppLocale,
      home: const HomeScreen(),
    );
  }
}
