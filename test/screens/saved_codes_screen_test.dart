import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/screens/saved_codes_screen/saved_codes_screen.dart';
import 'package:code_pocket/screens/saved_codes_screen/widgets/code_card.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_codes_store.dart';

void main() {
  final codes = [
    CodeData(
      id: 1,
      title: 'Boarding pass',
      data: 'flight-204',
      codeType: CodeType.qrCode,
      createdAt: DateTime(2026, 7, 29),
    ),
    CodeData(
      id: 2,
      title: 'Warehouse bin',
      data: 'BIN-492',
      codeType: CodeType.barCode,
      createdAt: DateTime(2026, 7, 28),
    ),
  ];

  test('filterSavedCodes searches names and payloads', () {
    expect(
      filterSavedCodes(
        codes,
        query: 'board',
        filter: SavedCodeFilter.all,
      ).single.title,
      'Boarding pass',
    );
    expect(
      filterSavedCodes(
        codes,
        query: '492',
        filter: SavedCodeFilter.all,
      ).single.title,
      'Warehouse bin',
    );
    expect(
      filterSavedCodes(
        codes,
        query: '',
        filter: SavedCodeFilter.qrCode,
      ).single.codeType,
      CodeType.qrCode,
    );
  });

  testWidgets('library distinguishes saved data and filtered results', (
    tester,
  ) async {
    final store = FakeCodesStore(initialCodes: codes);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dbServiceProvider.overrideWithValue(store)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: SavedCodesScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Boarding pass'), findsOneWidget);
    expect(find.text('Warehouse bin'), findsOneWidget);

    final filterWidths = [
      tester.getSize(find.widgetWithText(ChoiceChip, 'All')).width,
      tester.getSize(find.widgetWithText(ChoiceChip, 'QR codes')).width,
      tester.getSize(find.widgetWithText(ChoiceChip, 'Barcodes')).width,
    ];
    expect(filterWidths[0], closeTo(filterWidths[1], 0.01));
    expect(filterWidths[1], closeTo(filterWidths[2], 0.01));
    expect(
      tester.getSize(find.byKey(const ValueKey('library-filter-row'))).width,
      closeTo(tester.getSize(find.byType(SearchBar)).width, 0.01),
    );

    await tester.enterText(find.byType(SearchBar), 'missing');
    await tester.pumpAndSettle();
    expect(find.text('No matching codes'), findsOneWidget);
  });

  testWidgets('library exposes an actionable loading failure', (tester) async {
    final store = FakeCodesStore()..loadError = StateError('offline');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dbServiceProvider.overrideWithValue(store)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: SavedCodesScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Library unavailable'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('single-code deletion is guarded by confirmation', (
    tester,
  ) async {
    final store = FakeCodesStore(initialCodes: [codes.first]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dbServiceProvider.overrideWithValue(store)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: SavedCodesScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Code options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete this code?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Boarding pass'), findsOneWidget);
    expect(store.codes, hasLength(1));

    await tester.tap(find.byTooltip('Code options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(store.codes, isEmpty);
    expect(find.text('Your library is empty'), findsOneWidget);
  });

  test('saved dates have readable relative and calendar labels', () {
    final now = DateTime(2026, 7, 30, 12);
    expect(formatSavedCodeDate(null, now: now), 'Saved');
    expect(
      formatSavedCodeDate(DateTime(2026, 7, 30, 11, 30), now: now),
      '30 min ago',
    );
    expect(
      formatSavedCodeDate(DateTime(2026, 7, 29, 12), now: now),
      'Yesterday',
    );
    expect(formatSavedCodeDate(DateTime(2026, 7, 1), now: now), '01/07/2026');
  });
}
