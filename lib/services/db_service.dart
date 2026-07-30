import 'package:code_pocket/models/code_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class _TableNames {
  static const codeData = "code_data";
}

class _CodeDataColums {
  static const id = "id";
  static const title = "title";
  static const data = "data";
  static const codeType = "code_type";
  static const createdAt = "created_at";
}

abstract interface class CodesStore {
  Future<int> insertCode(CodeData code);

  Future<List<CodeData>> getAllCodes();

  Future<void> deleteCode(int id);

  Future<void> deleteAllCodes();

  Future<void> updateCode(CodeData code);
}

class DbService implements CodesStore {
  static final DbService instance = DbService._instance();
  static Database? _database;

  DbService._instance();

  Future<Database> _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'geeksforgeeks.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<Database> get db async {
    _database ??= await _initDb();
    return _database!;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${_TableNames.codeData} (
      ${_CodeDataColums.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${_CodeDataColums.title} TEXT NOT NULL UNIQUE,
      ${_CodeDataColums.data} TEXT NOT NULL,
      ${_CodeDataColums.codeType} TEXT NOT NULL,
      ${_CodeDataColums.createdAt} TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
  ''');
  }

  @override
  Future<int> insertCode(CodeData code) async {
    Database db = await instance.db;
    try {
      return await db.insert(
        _TableNames.codeData,
        code.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CodeData>> getAllCodes() async {
    Database db = await instance.db;
    final List<Map<String, dynamic>> maps = await db.query(
      _TableNames.codeData,
      orderBy: '${_CodeDataColums.id} DESC',
    );

    if (maps.isEmpty) return [];

    return List.generate(maps.length, (i) {
      return CodeData.fromMap(maps[i]);
    });
  }

  @override
  Future<void> deleteCode(int id) async {
    Database db = await instance.db;
    await db.delete(
      _TableNames.codeData,
      where: '${_CodeDataColums.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteAllCodes() async {
    Database db = await instance.db;
    await db.delete(_TableNames.codeData);
  }

  @override
  Future<void> updateCode(CodeData code) async {
    Database db = await instance.db;
    await db.update(
      _TableNames.codeData,
      code.toMap(),
      where: '${_CodeDataColums.id} = ?',
      whereArgs: [code.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
