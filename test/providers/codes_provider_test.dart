import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_codes_store.dart';

void main() {
  test('adding a code preserves the previously loaded library', () async {
    final store = FakeCodesStore(
      initialCodes: [
        CodeData(
          id: 1,
          title: 'Existing',
          data: 'existing-value',
          codeType: CodeType.qrCode,
        ),
      ],
    );
    final container = ProviderContainer(
      overrides: [dbServiceProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    await container.read(codesProvider.future);
    final savedCode = await container
        .read(codesProvider.notifier)
        .addCode(
          CodeData(title: 'New', data: 'new-value', codeType: CodeType.barCode),
        );

    final codes = container.read(codesProvider).requireValue;
    expect(savedCode.id, 2);
    expect(savedCode.createdAt, isNotNull);
    expect(codes.map((code) => code.title), ['New', 'Existing']);
  });

  test('deleting a code updates storage and provider state', () async {
    final store = FakeCodesStore(
      initialCodes: [
        CodeData(
          id: 7,
          title: 'Temporary',
          data: 'value',
          codeType: CodeType.qrCode,
        ),
      ],
    );
    final container = ProviderContainer(
      overrides: [dbServiceProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    await container.read(codesProvider.future);
    await container.read(codesProvider.notifier).deleteCode(7);

    expect(container.read(codesProvider).requireValue, isEmpty);
    expect(store.codes, isEmpty);
  });
}
