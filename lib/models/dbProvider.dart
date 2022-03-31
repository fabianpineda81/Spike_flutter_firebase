import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spike_firebase/herpers/helper_toas.dart';
import 'package:spike_firebase/models/MTraslations.dart';
import 'package:sqflite/sqflite.dart';

import 'MImage.dart';
import 'MRelations.dart';
import 'Mfolder.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "spike.db");
    return await openDatabase(
      path,
      version: 6,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        HelperToast.showToast("creando tablas");
        db.rawQuery(MImage.createTableScript);
        db.rawQuery(MFolder.createTableScript);
        db.rawQuery(MRelation.createTableScript);
        db.rawQuery(Translation.createTableScript);

      },

    );
  }
}