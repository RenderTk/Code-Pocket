import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/services/db_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dbServiceProvider = Provider<CodesStore>((ref) => DbService.instance);

class CodesNotifier extends AsyncNotifier<List<CodeData>> {
  @override
  Future<List<CodeData>> build() async {
    return ref.read(dbServiceProvider).getAllCodes();
  }

  List<CodeData> _makeDeepCopy() {
    return state.value?.map((e) => e.copyWith()).toList() ?? [];
  }

  Future<void> refreshCodes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(dbServiceProvider).getAllCodes();
    });
  }

  Future<CodeData> addCode(CodeData code) async {
    final codes = _makeDeepCopy();
    final id = await ref.read(dbServiceProvider).insertCode(code);
    final savedCode = code.copyWith(
      id: id,
      createdAt: code.createdAt ?? DateTime.now(),
    );

    state = AsyncValue.data([savedCode, ...codes]);
    return savedCode;
  }

  Future<void> deleteCode(int id) async {
    final previousCodes = _makeDeepCopy();
    final updatedCodes = previousCodes
        .where((code) => code.id != id)
        .toList(growable: false);
    state = AsyncValue.data(updatedCodes);

    try {
      await ref.read(dbServiceProvider).deleteCode(id);
    } catch (e, st) {
      state = AsyncValue.data(previousCodes);
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<void> deleteAllCodes() async {
    final previousCodes = _makeDeepCopy();
    state = const AsyncValue.data([]);

    try {
      await ref.read(dbServiceProvider).deleteAllCodes();
    } catch (e, st) {
      state = AsyncValue.data(previousCodes);
      Error.throwWithStackTrace(e, st);
    }
  }

  bool exists(String title) {
    final codes = state.value ?? [];
    return codes.any((code) => code.title == title);
  }
}

final codesProvider = AsyncNotifierProvider<CodesNotifier, List<CodeData>>(
  CodesNotifier.new,
);
