import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CodeType { qrCode, barCode }

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
