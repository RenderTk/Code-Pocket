import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/screens/scan_code_screen/scan_code_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  test('QR formats map to QR code and other formats map to barcode', () {
    expect(codeTypeForBarcodeFormat(BarcodeFormat.qrCode), CodeType.qrCode);
    expect(codeTypeForBarcodeFormat(BarcodeFormat.code128), CodeType.barCode);
    expect(codeTypeForBarcodeFormat(BarcodeFormat.ean13), CodeType.barCode);
  });

  test('code types expose their intended payload limits', () {
    expect(CodeType.qrCode.maxLength, 3000);
    expect(CodeType.barCode.maxLength, 100);
  });
}
