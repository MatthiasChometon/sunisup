import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/city.dart';

class CityDatabase {
  static final CityDatabase instance = CityDatabase._init();

  static Database? _database;

  CityDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('City.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $TableCity(
      ${CityFields.Id_city} $idType,
      ${CityFields.Libelle} $textType
    )
    ''');
  }

  Future<String> CreateCity(libelle) async {
    final db = await instance.database;
    final city = City(Libelle: libelle);
    String val = await db.insert(TableCity, city.toJson()).toString();
    return val;
  }

  Future<List<City>> FetchAllCity() async {
    var db = await instance.database;

    const orderBy = '${CityFields.Libelle} ASC';

    final result = await db.query(TableCity, orderBy: orderBy);

    return result.map((json) => City.fromJson(json)).toList();
  }

  Future<int> DeleteCity(int Id_city) async {
    var db = await instance.database;
    return db.delete(
      TableCity,
      where: '${CityFields.Id_city} = ?',
      whereArgs: [Id_city],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
