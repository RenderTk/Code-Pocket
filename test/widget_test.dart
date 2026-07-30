import 'package:code_pocket/main.dart';
import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_codes_store.dart';

void main() {
  Widget buildApp(FakeCodesStore store) {
    return ProviderScope(
      overrides: [dbServiceProvider.overrideWithValue(store)],
      child: const MyApp(),
    );
  }

  testWidgets('home exposes the three balanced tools', (tester) async {
    await tester.pumpWidget(buildApp(FakeCodesStore()));
    await tester.pumpAndSettle();

    expect(find.text('Code Pocket'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Create a code'), findsOneWidget);
  });

  testWidgets('create form state survives tab changes', (tester) async {
    await tester.pumpWidget(buildApp(FakeCodesStore()));
    await tester.pumpAndSettle();

    final nameField = find.byType(TextFormField).first;
    await tester.enterText(nameField, 'Conference ticket');
    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    expect(find.text('Your library is empty'), findsOneWidget);

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(find.text('Conference ticket'), findsOneWidget);
  });

  testWidgets('barcode selection updates labels and limits', (tester) async {
    await tester.pumpWidget(buildApp(FakeCodesStore()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Barcode'));
    await tester.pumpAndSettle();

    expect(find.text('Generate barcode'), findsOneWidget);
    expect(find.textContaining('Code 128 barcodes'), findsOneWidget);
    expect(find.text('0/100'), findsOneWidget);
  });

  testWidgets('valid create form opens the preview', (tester) async {
    await tester.pumpWidget(buildApp(FakeCodesStore()));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Portfolio');
    await tester.enterText(fields.at(1), 'https://example.com');
    await tester.ensureVisible(find.text('Generate QR code'));
    await tester.tap(find.text('Generate QR code'));
    await tester.pumpAndSettle();

    expect(find.text('Preview'), findsOneWidget);
    expect(find.text('Portfolio'), findsOneWidget);
    expect(find.text('Save to library'), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
  });

  testWidgets('saving resets the create form without stale validation', (
    tester,
  ) async {
    final store = FakeCodesStore();
    await tester.pumpWidget(buildApp(store));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Saved ticket');
    await tester.enterText(fields.at(1), 'https://example.com/ticket');
    await tester.ensureVisible(find.text('Generate QR code'));
    await tester.tap(find.text('Generate QR code'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save to library'));
    await tester.tap(find.widgetWithText(FilledButton, 'Save to library'));
    try {
      await tester.pumpAndSettle();
    } on FlutterError catch (error) {
      expect(error.message, contains('pumpAndSettle timed out'));
    }

    expect(store.codes, hasLength(1));
    expect(find.text('Create a code'), findsOneWidget);
    expect(find.text('Enter a name for this QR Code.'), findsNothing);
    expect(find.text('Enter the value you want to encode.'), findsNothing);
    expect(find.text('Saved ticket'), findsNothing);
  });

  testWidgets('duplicate names are rejected before preview navigation', (
    tester,
  ) async {
    final store = FakeCodesStore(
      initialCodes: [
        CodeData(
          id: 1,
          title: 'Existing pass',
          data: 'saved-value',
          codeType: CodeType.qrCode,
        ),
      ],
    );
    await tester.pumpWidget(buildApp(store));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Existing pass');
    await tester.enterText(fields.at(1), 'new-value');
    await tester.ensureVisible(find.text('Generate QR code'));
    await tester.tap(find.text('Generate QR code'));
    await tester.pump();

    expect(find.text('A saved code already uses this name.'), findsOneWidget);
    expect(find.text('Preview'), findsNothing);
  });

  testWidgets('delete all requires explicit confirmation', (tester) async {
    final store = FakeCodesStore(
      initialCodes: [
        CodeData(
          id: 1,
          title: 'Temporary pass',
          data: 'temporary-value',
          codeType: CodeType.qrCode,
        ),
      ],
    );
    await tester.pumpWidget(buildApp(store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Library options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete all'));
    await tester.pumpAndSettle();

    expect(find.text('Delete every saved code?'), findsOneWidget);
    expect(store.codes, isNotEmpty);

    await tester.tap(find.widgetWithText(FilledButton, 'Delete all'));
    await tester.pumpAndSettle();
    expect(store.codes, isEmpty);
    expect(find.text('Your library is empty'), findsOneWidget);
  });
}
