import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/screens/scan_result_screen/scan_result_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_codes_store.dart';
import '../support/localized_test_app.dart';

void main() {
  testWidgets('scan result keeps copy and share independent from saving', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dbServiceProvider.overrideWithValue(FakeCodesStore())],
        child: const LocalizedTestApp(
          home: ScanResultScreen(
            data: 'https://example.com',
            codeType: CodeType.qrCode,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Code captured'), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Save to library'), findsOneWidget);

    await tester.ensureVisible(find.text('Save to library'));
    await tester.tap(find.text('Save to library'));
    await tester.pump();
    expect(find.text('Enter a name before saving.'), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
  });
}
