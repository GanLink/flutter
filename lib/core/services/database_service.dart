
import 'package:ganlink/features/bovinue/domain/bovinue.dart';
import 'package:ganlink/features/farm/domain/farm.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  // Singleton instance
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, 'ganlink.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE farms(
        id INTEGER PRIMARY KEY,
        alias TEXT,
        mainActivity TEXT,
        ownerDni TEXT,
        userId INTEGER,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE bovinues(
        id INTEGER PRIMARY KEY,
        farmId INTEGER
      )
    ''');
  }

  Future<void> addFarm(Farm farm) async {
    final db = await database;
    await db.insert(
      'farms',
      farm.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Farm>> getFarms(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'farms',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Farm.fromMap(maps[i]);
    });
  }

  Future<void> deleteFarm(int id) async {
    final db = await database;
    await db.delete(
      'farms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> addBovinue(Bovinue bovinue) async {
    final db = await database;
    await db.insert(
      'bovinues',
      bovinue.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Bovinue>> getBovinues(int farmId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bovinues',
      where: 'farmId = ?',
      whereArgs: [farmId],
    );
    return List.generate(maps.length, (i) {
      return Bovinue.fromMap(maps[i]);
    });
  }

  Future<void> deleteBovinue(int id) async {
    final db = await database;
    await db.delete(
      'bovinues',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearBovinues(int farmId) async {
    final db = await database;
    await db.delete(
      'bovinues',
      where: 'farmId = ?',
      whereArgs: [farmId],
    );
  }
}
