import 'package:flutter/cupertino.dart';

import 'dbProvider.dart';

class Translation{
  static const String TableName = 'translations';
  int id=-1; // internal ID of the translation
  String tableName;
  int itemId;
  String language;
  String textToShow;
  String textToSay;
  String user;
  static String createTableScript = "CREATE TABLE IF NOT EXISTS $TableName ("
      "id INTEGER PRIMARY KEY,"
      "tableName TEXT,"
      "itemId INTEGER,"
      "language TEXT,"
      "textToShow TEXT,"
      "textToSay TEXT,"
      "user TEXT"
      ")";

  Translation({ required this.tableName,required this.itemId,required this.language,
    required this.textToShow,required this.textToSay, required this.user,id});


  factory Translation.fromMap(Map<String, dynamic> json) => new Translation(
    id: json["id"],
    tableName: json["tableName"],
    itemId: json["itemId"],
    language: json["language"],
    textToShow: json["textToShow"],
    textToSay: json["textToSay"],
    user: json["user"]??'',
  );
  factory Translation.jsonToTranslations(Map<String, dynamic> json) => new Translation(
    id: json["idInDevice"],
    tableName: json["tableName"],
    itemId: json["itemId"],
    language: json["language"],
    textToShow: json["textToShow"],
    textToSay: json["textToSay"],
    user: json["user"]??'',
  );


  Map<String, dynamic> toMap() => {
    "id": id,
    "tableName": tableName,
    "itemId": itemId,
    "language": language,
    "textToShow": textToShow,
    "textToSay": textToSay,
    "user": user,
  };

  static Future<void> createWithID(Translation entity) async {
    final db = await DBProvider.db.database;
    await db?.insert("$TableName", entity.toMap());
    // var res = await db.insert("$TableName", entity.toMap());
    // return res;
  }



  static Future<void> create(Translation entity) async {
    final db = await DBProvider.db.database;

    //get the biggest id in the table
    var table = await db?.rawQuery("SELECT MAX(id)+1 as id FROM $TableName");
    Object oId = await table?.first["id"] ?? 1;
    int id= int.parse(oId.toString());
    //insert translation using the new id
    await db?.rawInsert(
        "INSERT Into $TableName (id,tableName,itemId,language,textToShow,textToSay)"
            " VALUES (?,?,?,?,?,?)",
        [
          id,
          entity.tableName,
          entity.itemId,
          entity.language,
          entity.textToShow,
          entity.textToSay
        ]);
  }
  static Future<List<Translation>> getAll() async {
    final db = await DBProvider.db.database;
    String sql = 'SELECT $TableName.* '
        'FROM $TableName ';
    var result = await db?.rawQuery(sql);
    List<Translation> list = result!.isNotEmpty
        ? result.toList().map((c) => Translation.fromMap(c)).toList()
        : <Translation>[];


    var r = list;

    r.sort((i1, i2) => i1.textToShow.compareTo(i2.textToShow));
    return r;

  }


  static Future<void> deleteById(int id) async {
    final db = await DBProvider.db.database;
    String sql = 'DELETE FROM $TableName WHERE '
        'id = $id ';
    await db?.rawQuery(sql);
  }

  static Future<int> maxId() async {
    int i = UniqueKey().hashCode;

    return i ;
  }
  Map toJson() {
    return toMap();
  }

  static Future<Translation?> getLocalized(
      String tableName, int itemId, String language) async {
    final db = await DBProvider.db.database;
    var results = await db!.rawQuery('SELECT * FROM $TableName WHERE '
        'tableName = "$tableName" '
        'AND itemId = $itemId '
        'AND language = "$language"');

    if (results.length > 0) {
      return new Translation.fromMap(results.first);
    }

    return null;
  }

  static Future<void> update(Translation entity) async {
    // esto
    final db = await DBProvider.db.database;
    await db?.update("$TableName", entity.toMap(),
        where: "id = ?", whereArgs: [entity.id]);
    // var result = await db.update("$TableName", entity.toMap(),
    //     where: "id = ?", whereArgs: [entity.id]);
    // return result;
  }

  static Future<void> deleteForObject(String tableName, int itemId) async {
    final db = await DBProvider.db.database;
    String sql = 'DELETE FROM $TableName WHERE '
        'tableName = "$tableName" '
        'AND itemId = $itemId ';
    await db?.rawQuery(sql);
  }





}