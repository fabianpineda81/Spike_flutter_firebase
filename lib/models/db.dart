import 'package:spike_firebase/models/animal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Db{
  static Future<Database> _openDB() async{
    return openDatabase(
      join(await getDatabasesPath(),'spike.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE animales (id INTEGER PRIMERY KEY,nombre TEXT, especie TEXT)",

        );
      },version: 1
    );
  }

  static Future<int> instert(Animal animal) async{
    Database database = await _openDB();
    return database.insert("animales", animal.toMap());

  }

  static Future<int> delete(Animal  animal) async{
    Database database= await _openDB();
    return database.delete("animanes",where: "id=?",whereArgs: [animal.id]);
  }

  static Future<int> update(Animal animal) async{
    Database database = await _openDB();
     return database.update("animales", animal.toMap(),where: "id=?",whereArgs: [animal.id]);

  }
  static Future<List<Animal>>animales()async{
    Database database = await _openDB();
    final  List<Map<String, dynamic>> animalesMap= await database.query("animales");
    return List.generate(animalesMap.length, (index) => Animal(
      id: animalesMap[index]["id"],
      nombre: animalesMap[index]["nombre"],
      especie: animalesMap[index]["especie"]

    ));
  }
}