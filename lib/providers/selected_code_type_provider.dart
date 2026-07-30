import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CodeType { qrCode, barCode }

enum SavedCodeFilter { all, qrCode, barCode }

extension CodeTypePresentation on CodeType {
  String get label => switch (this) {
    CodeType.qrCode => 'QR Code',
    CodeType.barCode => 'Barcode',
  };

  String get titleHint => switch (this) {
    CodeType.qrCode => 'Example: Event invitation',
    CodeType.barCode => 'Example: Inventory label',
  };

  String get dataHint => switch (this) {
    CodeType.qrCode => 'Paste a link, message, or any text',
    CodeType.barCode => 'Enter the value to encode',
  };

  String get generateLabel => switch (this) {
    CodeType.qrCode => 'Generate QR code',
    CodeType.barCode => 'Generate barcode',
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
  String get label => switch (this) {
    SavedCodeFilter.all => 'All',
    SavedCodeFilter.qrCode => 'QR codes',
    SavedCodeFilter.barCode => 'Barcodes',
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
