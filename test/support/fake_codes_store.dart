import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/services/db_service.dart';

class FakeCodesStore implements CodesStore {
  FakeCodesStore({List<CodeData>? initialCodes})
    : codes = [...?initialCodes],
      _nextId =
          (initialCodes ?? const <CodeData>[])
              .map((code) => code.id ?? 0)
              .fold<int>(0, (highest, id) => id > highest ? id : highest) +
          1;

  final List<CodeData> codes;
  int _nextId;
  Object? loadError;

  @override
  Future<void> deleteAllCodes() async {
    codes.clear();
  }

  @override
  Future<void> deleteCode(int id) async {
    codes.removeWhere((code) => code.id == id);
  }

  @override
  Future<List<CodeData>> getAllCodes() async {
    if (loadError case final error?) throw error;
    return [...codes];
  }

  @override
  Future<int> insertCode(CodeData code) async {
    if (codes.any((savedCode) => savedCode.title == code.title)) {
      throw StateError('Duplicate title');
    }
    final id = _nextId++;
    codes.insert(
      0,
      CodeData(
        id: id,
        title: code.title,
        data: code.data,
        codeType: code.codeType,
        createdAt: code.createdAt ?? DateTime.now(),
      ),
    );
    return id;
  }

  @override
  Future<void> updateCode(CodeData code) async {
    final index = codes.indexWhere((savedCode) => savedCode.id == code.id);
    if (index == -1) throw StateError('Code not found');
    codes[index] = code;
  }
}
