import 'package:barcode_widget/barcode_widget.dart';
import 'package:code_pocket/l10n/l10n.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CodeVisual extends StatelessWidget {
  const CodeVisual({
    super.key,
    required this.codeType,
    required this.data,
    this.size = 220,
    this.drawBarcodeText = true,
  });

  final CodeType codeType;
  final String data;
  final double size;
  final bool drawBarcodeText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Semantics(
      image: true,
      label: l10n.codeSemantics(codeType.label(l10n), data),
      child: codeType == CodeType.qrCode
          ? QrImageView(
              data: data,
              version: QrVersions.auto,
              size: size,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFF111722),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF111722),
              ),
              errorCorrectionLevel: QrErrorCorrectLevel.M,
            )
          : SizedBox(
              width: size,
              height: size * 0.44,
              child: BarcodeWidget(
                barcode: Barcode.code128(),
                data: data,
                drawText: drawBarcodeText,
                color: const Color(0xFF111722),
                backgroundColor: Colors.white,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF111722),
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
