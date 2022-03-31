import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'MTraslations.dart';
import 'Mobject.dart';
import 'dbProvider.dart';

class MImage extends MObject{
  static const String TableName = 'images';
  int minLevelToShow = 1; // min level for which the category will be shown
  String strBase64 = '';

  static String createTableScript = "CREATE TABLE IF NOT EXISTS $TableName ("
      "id INTEGER PRIMARY KEY,"
      "fileName TEXT,"
      "categoryId INTEGER,"
      "isVisible INTEGER,"
      "isUnderstood INTEGER,"
      "useAsset INTEGER,"
      "localFileName TEXT,"
      "userCreated INTEGER,"
      "isAvailable INTEGER,"
      "backgroundColor TEXT,"
      "minLevelToShow INTEGER,"
      "user TEXT,"
      "textToShow TEXT,"
      "textToSay TEXT"
      ")";// base 64 of image to show to user

  static List<MImage>? inMemoryTable;
  static Map<int, MImage>? inMemoryDictionary;
  MImage({
    required int id,
    String fileName = '',
    String textToShow = '',
    String textToSay = '',
    int categoryId = -1,
    int relationId = -1,
    int isVisible = 0,
    int isUnderstood = 0,
    String backgroundColor = '',
    int minColumn = 1,
    int maxColumn = 1,
    int minLevelToShow = 1,
    int useAsset = 1,
    String localFileName = '',
    int userCreated = 1,
    int isAvailable = 1,
    String user = '',
    int remoteId = -1,
  }) {
    this.id = id;
    this.fileName = fileName;
    this.textToShow = textToShow;
    this.textToSay = textToSay;

    this.relationId = relationId;

    this.categoryId = categoryId;
    if (this.categoryId == -1) {
      this.categoryId = 17;
    }

   // MCategory.getByID(this.categoryId).then((mCategory) {
    //  this.category = mCategory;
    //});

    if (this.textToShow == null) {
      this.textToShow = '';
    }

    if (this.textToSay == null) {
      this.textToSay = '';
    }

    if (this.fileName == null) {
      this.fileName = 'assets/Images/ui_empty.png';
    }

    if (this.fileName.isEmpty) {
      this.fileName = 'assets/Images/ui_empty.png';
    }

    this.isVisible = isVisible;
    this.isUnderstood = isUnderstood;
    this.backgroundColor = backgroundColor;
    this.minColumn = minColumn;
    this.maxColumn = maxColumn;
    this.minLevelToShow = minLevelToShow;
    this.useAsset = useAsset ;
    this.localFileName = localFileName;

    this.userCreated = userCreated;
    this.isAvailable = isAvailable;
    this.user = user;
  }
  factory MImage.fromMap(Map<String, dynamic> json) => MImage(
    id: json["id"],
    fileName: json["fileName"],
    categoryId: json["categoryId"]??-1,
    textToShow: json["textToShow"]??'',
    textToSay: json["textToSay"]??'',
    relationId: json["relationId"]??-1,
    isVisible: json["isVisible"],
    isUnderstood: json["isUnderstood"],
    backgroundColor: json["backgroundColor"],
    minColumn: json["minColumn"]??1,
    maxColumn: json["maxColumn"]??1,
    minLevelToShow: json["minLevelToShow"]??1,
    useAsset: json["useAsset"]??1,
    localFileName: json["localFileName"],
    userCreated: json["userCreated"]??1,
    isAvailable: json["isAvailable"]??1,
    user: json["user"]??''
        '',
  );
  // TODO hay que crear este metodo en lucas
  factory MImage.jsonToImage(Map<String, dynamic> json) => MImage(
    id: json["idInDevice"],
    fileName: json["fileName"],
    categoryId: json["categoryId"]??-1,
    textToShow: json["textToShow"]??'',
    textToSay: json["textToSay"]??'',
    relationId: json["relationId"]??-1,
    isVisible: json["isVisible"],
    isUnderstood: json["isUnderstood"],
    backgroundColor: json["backgroundColor"],
    minColumn: json["minColumn"]??1,
    maxColumn: json["maxColumn"]??1,
    minLevelToShow: json["minLevelToShow"]??1,
    useAsset: json["useAsset"]??1,
    localFileName: json["localFileName"],
    userCreated: json["userCreated"]??1,
    isAvailable: json["isAvailable"]??1,
    user: json["user"]??''
        '',
  );


  static Future<void> createWithID(MImage entity) async {
    final db = await DBProvider.db.database;
    // var res = await db.insert("$TableName", entity.toMap());
    // return res;

    await db?.rawInsert(
        "INSERT Into $TableName (id,fileName,categoryId, isVisible, isUnderstood, useAsset, localFileName, userCreated,isAvailable,user,backgroundColor,textToShow,textToSay)"
            " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",
        [
          entity.id,
          entity.fileName,
          entity.categoryId,
          entity.isVisible,
          entity.isUnderstood,
          entity.useAsset,
          entity.localFileName,
          entity.userCreated,
          entity.isAvailable,
          entity.user,
          entity.backgroundColor,
          entity.textToShow,
          entity.textToSay
        ]);


  }
  static Future<void> update(MImage entity) async {
    final db = await DBProvider.db.database;
    await db?.update("$TableName", entity.toBDMap(),
        where: "id = ?", whereArgs: [entity.id]);


  }

  static Future<int> maxId() async {
    int i = UniqueKey().hashCode;

    return i ;
  }

  Map<String, dynamic> toBDMap() => {
    "id": id,
    "fileName": fileName,
    "categoryId": categoryId,
    "isVisible": isVisible,
    "isUnderstood": isUnderstood,
    "useAsset": useAsset,
    "localFileName": localFileName,
    "userCreated": userCreated,
    "isAvailable": isAvailable,
    "backgroundColor": backgroundColor,
    "minLevelToShow": minLevelToShow,
    "user": user,
  };
  static Future<void> delete(MObject mobject) async {
    final db = await DBProvider.db.database;
    await db?.rawQuery("delete from $TableName WHERE id=${mobject.id}");


  }

  static Future<void> backup({required String  userEmail,required String userName}) async {

    List<MImage> objects = await getAll();

    //String jsonEntity = jsonEncode(objects);
    String json = jsonEncode({
      "email": userEmail,
      "name": userName,
      "operation": "upload MImage list",
      "objects": objects,
    });


  }

  static Future<List<MImage>> getAll() async {
    final db = await DBProvider.db.database;
    final List<Map<String, Object?>> result = await db!.query(TableName);
    List<MImage>? list = result.isNotEmpty ? result.toList().map((c) => MImage.fromMap(c)).toList()
        : <MImage>[];

    return list;
  }

  static Future<MImage?> getByID(int id) async {

    String languageCode ="en";
    //await LocalPreferences.getString('languageCode', 'en');

    final db = await DBProvider.db.database;
    String sql = 'SELECT $TableName.*, '
        '${Translation.TableName}.textToShow, ${Translation.TableName}.textToSay '
    //'${MCategory.TableName}.backgroundColor, ${MCategory.TableName}.minColumn, '
    // '${MCategory.TableName}.minColumn, '
    // '${MCategory.TableName}.maxColumn '
    //'${MCategory.TableName}.maxColumn, ${MCategory.TableName}.minLevelToShow '
        'FROM $TableName '
        'LEFT JOIN ${Translation.TableName} '
        'ON ${Translation.TableName}.language="$languageCode" '
        'AND ${Translation.TableName}.tableName="${MImage.TableName}" '
        'AND ${Translation.TableName}.itemId=$TableName.id '
        'WHERE $TableName.id = $id';

    final List<Map<String, Object?>> result = await db!.rawQuery(sql);
    List<MImage>? list = result.isNotEmpty ? result.toList().map((c) => MImage.fromMap(c)).toList()
        : <MImage>[];

    try{
      return list.first;
    }catch(e){
      return null;
    }



   /* final db = await DBProvider.db.database;
    final List<Map<String, Object?>> result = await db!.query(TableName,where: "id=?",whereArgs: [id]);
    List<MImage>? list = result.isNotEmpty ? result.toList().map((c) => MImage.fromMap(c)).toList()
        : <MImage>[];

    try{
      return list.first;
    }catch(e){
      return null;
    }*/
  }
  Map toJson() {
    return toBDMap();
  }




}