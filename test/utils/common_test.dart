import 'package:code_pocket/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('share origin is non-zero and inside the current view', (
    tester,
  ) async {
    late Rect shareOrigin;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            shareOrigin = sharePositionOriginFor(context);
            return const SizedBox.expand();
          },
        ),
      ),
    );

    final viewSize = tester.view.physicalSize / tester.view.devicePixelRatio;
    expect(shareOrigin.isEmpty, isFalse);
    expect(shareOrigin.left, greaterThanOrEqualTo(0));
    expect(shareOrigin.top, greaterThanOrEqualTo(0));
    expect(shareOrigin.right, lessThanOrEqualTo(viewSize.width));
    expect(shareOrigin.bottom, lessThanOrEqualTo(viewSize.height));
  });
}
