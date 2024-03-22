import 'dart:async';
import 'package:geo_silent/constant/modal.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase("globus_bd_v1.db", version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Places (id INTEGER PRIMARY KEY autoincrement, name TEXT, mode INTEGER, days TEXT, points TEXT );');
    });
    return _database;
  }

  Future insertPlace(Place place) async {
    await openDb();
    return await _database.insert('Places', place.toJson());
  }

  Future deletePlace(int id) async {
    await openDb();
    return await _database.delete('Places', where: 'id = $id');
  }

  Future<List<Place>> getPlaceList() async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery("SELECT * FROM Places");

    return List.generate(maps.length, (i) {
      return Place(
          id: maps[i]['id'],
          name: maps[i]['name'],
          mode: maps[i]['mode'],
          days: maps[i]['days'],
          points: maps[i]['points']);
    });
  }
}
