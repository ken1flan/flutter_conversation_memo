import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper _instance;

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._();

    return _instance;
  }

  const DatabaseHelper._();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'conversation_database.db'),
      onCreate: (db, version) {
        _onCreate(db, version);
      },
      version: 1,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE topics(id INTEGER PRIMARY KEY, summary TEXT, memo TEXT, tags_string TEXT, created_at INTEGER, updated_at INTEGER)',
    );
  }
}
