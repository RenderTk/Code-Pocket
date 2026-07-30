import 'package:code_pocket/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CodeType { qrCode, barCode }

enum SavedCodeFilter { all, qrCode, barCode }

extension CodeTypePresentation on CodeType {
  String label(AppLocalizations l10n) => switch (this) {
    CodeType.qrCode => l10n.qrCode,
    CodeType.barCode => l10n.barcode,
  };

  String titleHint(AppLocalizations l10n) => switch (this) {
    CodeType.qrCode => l10n.qrTitleHint,
    CodeType.barCode => l10n.barcodeTitleHint,
  };

  String dataHint(AppLocalizations l10n) => switch (this) {
    CodeType.qrCode => l10n.qrDataHint,
    CodeType.barCode => l10n.barcodeDataHint,
  };

  String generateLabel(AppLocalizations l10n) => switch (this) {
    CodeType.qrCode => l10n.generateQrCode,
    CodeType.barCode => l10n.generateBarcode,
  };

  String nameRequiredError(AppLocalizations l10n) => switch (this) {
    CodeType.qrCode => l10n.qrNameRequired,
    CodeType.barCode => l10n.barcodeNameRequired,
  };

  String tooLongError(AppLocalizations l10n) => switch (this) {
    CodeType.qrCode => l10n.qrTooLong(maxLength),
    CodeType.barCode => l10n.barcodeTooLong(maxLength),
  };

  String detectedMessage(AppLocalizations l10n) => switch (this) {
    CodeType.qrCode => l10n.qrDetected,
    CodeType.barCode => l10n.barcodeDetected,
  };

  String scannedShareTitle(AppLocalizations l10n) => switch (this) {
    CodeType.qrCode => l10n.scannedQrShareTitle,
    CodeType.barCode => l10n.scannedBarcodeShareTitle,
  };

  int get maxLength => switch (this) {
    CodeType.qrCode => 3000,
    CodeType.barCode => 100,
  };

  IconData get icon => switch (this) {
    CodeType.qrCode => Icons.qr_code_2_rounded,
    CodeType.barCode => Icons.view_week_rounded,
  };
}

extension SavedCodeFilterPresentation on SavedCodeFilter {
  String label(AppLocalizations l10n) => switch (this) {
    SavedCodeFilter.all => l10n.all,
    SavedCodeFilter.qrCode => l10n.qrCodes,
    SavedCodeFilter.barCode => l10n.barcodes,
  };

  bool includes(CodeType type) => switch (this) {
    SavedCodeFilter.all => true,
    SavedCodeFilter.qrCode => type == CodeType.qrCode,
    SavedCodeFilter.barCode => type == CodeType.barCode,
  };
}

class SelectedCodeTypeProvider extends Notifier<CodeType> {
  @override
  CodeType build() {
    return CodeType.qrCode;
  }

  void setCodeType(CodeType type) {
    state = type;
  }
}

final selectedCodeTypeProvider =
    NotifierProvider<SelectedCodeTypeProvider, CodeType>(
      SelectedCodeTypeProvider.new,
    );
