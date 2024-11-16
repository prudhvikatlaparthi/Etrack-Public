import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/internal/olocation.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;
  static late final Future<Database> _database;

  DatabaseHelper._internal() {
    _database = _initDatabase();
  }

  Future<Database> get database async {
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'locations.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE locations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        message TEXT,
        timestamp TEXT,
        synced TEXT     
      )
      ''',
    );
  }

  Future<int> insertLocation(OLocation location) async {
    Database db = await database;
    return await db.insert('locations', location.toMap());
  }

  Future<List<OLocation>> getLocationsAll() async {
    Database db = await database;
    var result = await db.query('locations');
    return result.map((e) => OLocation.fromMap(e)).toList();
  }

  Future<List<OLocation>> getUnSyncedLocations() async {
    Database db = await database;
    var result = await db.query('locations', where: 'synced = ?', whereArgs: ['N']);
    return result.map((e) => OLocation.fromMap(e)).toList();
  }

  Future<int> removeLocation(List<int> ids) async {
    Database db = await database;
    String idsString = ids.join(',');
    return await db.delete('locations', where: 'id IN ($idsString)');
  }
}
