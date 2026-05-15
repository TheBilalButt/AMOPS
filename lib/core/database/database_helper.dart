/// ================================================
/// File    : database_helper.dart
/// Module  : Core
/// Desc    : SQLite helper for offline caching
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('amops_cache.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Create cache tables for all collections
    await db.execute('''
      CREATE TABLE drones_cache (
        id TEXT PRIMARY KEY,
        battery INTEGER,
        altitude INTEGER,
        signal INTEGER,
        status TEXT,
        camera TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE vehicles_cache (
        id TEXT PRIMARY KEY,
        type TEXT,
        fuel INTEGER,
        ammo INTEGER,
        engine_hours INTEGER,
        status TEXT,
        readiness INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE threats_cache (
        id TEXT PRIMARY KEY,
        sector TEXT,
        type TEXT,
        risk TEXT,
        description TEXT,
        timestamp TEXT
      )
    ''');
    
    // Add other tables as needed for offline support
  }

  Future<void> cacheData(String table, List<Map<String, dynamic>> data) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var item in data) {
      batch.insert(table, item, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getCachedData(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
