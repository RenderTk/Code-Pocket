import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/services/db_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CodesNotifier extends AsyncNotifier<List<CodeData>> {
  final DbService _dbService = DbService.instance;

  @override
  Future<List<CodeData>> build() async {
    final codes = await _dbService.getAllCodes();
    return codes;
  }

  List<CodeData> _makeDeepCopy() {
    return state.value?.map((e) => e.copyWith()).toList() ?? [];
  }

  Future<void> refreshCodes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final codes = await _dbService.getAllCodes();
      return codes;
    });
  }

  Future<void> addCode(CodeData code) async {
    state = const AsyncValue.loading();

    final codes = _makeDeepCopy();

    state = await AsyncValue.guard(() async {
      //update state on sqlite
      int id = await _dbService.insertCode(code);

      //update state on provider
      codes.insert(0, code.copyWith(id: id));
      return codes;
    });
  }

  Future<void> deleteCode(int id) async {
    state = const AsyncValue.loading();

    final codes = _makeDeepCopy();

    state = await AsyncValue.guard(() async {
      //update state on sqlite
      await _dbService.deleteCode(id);

      //update state on provider
      codes.removeWhere((code) => code.id == id);
      return codes;
    });
  }

  bool exists(String title) {
    final codes = state.value ?? [];
    return codes.any((code) => code.title == title);
  }

  void clearError() {
    state = AsyncValue.data(_makeDeepCopy());
  }
}

final codesProvider = AsyncNotifierProvider<CodesNotifier, List<CodeData>>(
  CodesNotifier.new,
);
