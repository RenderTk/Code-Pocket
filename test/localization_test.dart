import 'package:code_pocket/l10n/l10n.dart';
import 'package:code_pocket/main.dart';
import 'package:code_pocket/providers/codes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_codes_store.dart';

void main() {
  test('locale resolution matches language and defaults to English', () {
    expect(
      resolveAppLocale(const [
        Locale('es', 'HN'),
      ], AppLocalizations.supportedLocales),
      const Locale('es'),
    );
    expect(
      resolveAppLocale(const [
        Locale('en', 'GB'),
      ], AppLocalizations.supportedLocales),
      const Locale('en'),
    );
    expect(
      resolveAppLocale(const [
        Locale('fr', 'FR'),
      ], AppLocalizations.supportedLocales),
      const Locale('en'),
    );
  });

  testWidgets('Spanish OS locale displays the Spanish interface', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const [
      Locale('es', 'HN'),
    ];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dbServiceProvider.overrideWithValue(FakeCodesStore())],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Crear'), findsOneWidget);
    expect(find.text('Escanear'), findsOneWidget);
    expect(find.text('Biblioteca'), findsOneWidget);
    expect(find.text('Crear un código'), findsOneWidget);
  });

  testWidgets('unsupported OS locale displays the English interface', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const [
      Locale('fr', 'FR'),
    ];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dbServiceProvider.overrideWithValue(FakeCodesStore())],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Create a code'), findsOneWidget);
  });
}
