import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part "code_data.g.dart";

@CopyWith()
class CodeData {
  final int? id;
  final String title;
  final String data;
  final CodeType codeType;
  final DateTime? createdAt;

  CodeData({
    this.id,
    required this.title,
    required this.data,
    required this.codeType,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'data': data,
      'code_type': codeType == CodeType.qrCode ? 'qr_code' : 'barcode',
    };
  }

  factory CodeData.fromMap(Map<String, dynamic> map) {
    return CodeData(
      id: map['id'] as int,
      title: map['title'] as String,
      data: map['data'] as String,
      codeType: map['code_type'] == 'qr_code'
          ? CodeType.qrCode
          : CodeType.barCode,
      createdAt: DateTime.tryParse(map['created_at'] as String),
    );
  }
}
