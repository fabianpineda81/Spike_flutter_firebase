import 'dart:convert';

import 'package:spike_firebase/models/Mobject.dart';

import 'dbProvider.dart';

class MFolder extends MObject{
  static const String TableName = 'folders';

  //static List<MFolder> folders = List<MFolder>();
  static String createTableScript = "CREATE TABLE IF NOT EXISTS $TableName ("
      "id INTEGER PRIMARY KEY,"
      "parentFolderId INTEGER,"
      "fileName TEXT,"
      "categoryId INTEGER,"
      "isVisible INTEGER,"
      "isUnderstood INTEGER,"
      "userCreated INTEGER,"
      "isAvailable INTEGER,"
      "useAsset INTEGER,"
      "localFileName TEXT,"
      "backgroundColor TEXT,"
      "minLevelToShow INTEGER,"
      "user TEXT"
      ")";

  int? parentFolderId;

  MFolder({
    int id = -1,
    String fileName = '',
    String textToShow = '',
    String textToSay = '',
    int parentFolderId = -1,
    int categoryId = -1,
    int relationId = -1,
    int isVisible = 0,
    int isUnderstood = 0,
    String backgroundColor = '',
    int minColumn = 1,
    int maxColumn = 1,
    int minLevelToShow = 1,
    int userCreated = 1,
    int isAvailable = 1,
    int useAsset = 1,
    String localFileName = '',
    String user = '',
    int remoteId = -1,
  }) {
    this.id = id;
    this.fileName = fileName;
    this.textToShow = textToShow;
    this.textToSay = textToSay;
    this.parentFolderId = parentFolderId;
    this.categoryId = categoryId;
    this.isUnderstood = isUnderstood;

    this.categoryId = categoryId;
    if (this.categoryId == -1) {
      this.categoryId = 17;
    }


    if (this.textToShow == null) {
      this.textToShow = '';
    }

    if (this.textToSay == null) {
      this.textToSay = '';
    }

    if (this.fileName == null) {
      this.fileName = 'assets/images/folders_folder.png';
    }

    if (this.fileName.isEmpty) {
      this.fileName = 'assets/images/folders_folder.png';
    }

    this.isVisible = isVisible;
    this.backgroundColor = backgroundColor;
    this.minColumn = minColumn;
    this.maxColumn = maxColumn ;
    this.minLevelToShow = minLevelToShow ;

    this.userCreated = userCreated ;
    this.isAvailable = isAvailable;

    this.useAsset = useAsset ;
    this.localFileName = localFileName;
    this.user = user;
  }

  static Future<void> createWithID(MFolder entity) async {
    final db = await DBProvider.db.database;
    // var res = await db.insert("$TableName", entity.toMap());
    // return res;

    await db?.rawInsert(
        "INSERT Into $TableName (id,parentFolderId,fileName,categoryId, isVisible, isUnderstood, userCreated, isAvailable, useAsset, localFileName,user,backgroundColor) "
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
        [
          entity.id,
          entity.parentFolderId,
          entity.fileName,
          entity.categoryId,
          entity.isVisible,
          entity.isUnderstood,
          entity.userCreated,
          entity.isAvailable,
          entity.useAsset,
          entity.localFileName,
          entity.user,
          entity.backgroundColor,
        ]);



  }
  static Future<void> update(MFolder entity) async {
    final db = await DBProvider.db.database;
    await db?.update("$TableName", entity.toBDMap(),
        where: "id = ?", whereArgs: [entity.id]);


  }

  static Future<void> delete(MObject mobject) async {
    final db = await DBProvider.db.database;
    await db?.rawQuery("delete from $TableName WHERE id=${mobject.id}");


  }

  static Future<void> deleteAll() async {
    final db = await DBProvider.db.database;
    await db?.rawQuery("delete from $TableName");


  }

  static Future<int> maxId() async {
    final db = await DBProvider.db.database;

    var table = await db?.rawQuery("SELECT MAX(id)+1 as id FROM $TableName");
    Object maxId = await table?.first["id"] ?? 1;

    return int.parse(maxId.toString());
  }
  Map<String, dynamic> toBDMap() => {
    "id": id,
    "parentFolderId": parentFolderId,
    "fileName": fileName,
    "categoryId": categoryId,
    "isVisible": isVisible,
    "isUnderstood": isUnderstood,
    "userCreated": userCreated,
    "isAvailable": isAvailable,
    "useAsset": useAsset,
    "localFileName": localFileName,
    "backgroundColor": backgroundColor,
    "minLevelToShow": minLevelToShow,
    "user": user,
  };

  static Future<void> backup({required String userEmail, required String userName}) async {

    List<MFolder> objects = await getAll();

    //String jsonEntity = jsonEncode(objects);
    String json = jsonEncode({
      "email": userEmail,
      "name": userName,
      "operation": "upload MFolder list",
      "objects": objects,
    });

  }

  static Future<List<MFolder>> getAll() async {
    final db = await DBProvider.db.database;
    final List<Map<String, Object?>> result = await db!.query(TableName);
    List<MFolder>? list = result.isNotEmpty ? result.toList().map((c) => MFolder.fromMap(c)).toList()
        : <MFolder>[];

    return list;
  }

  factory MFolder.fromMap(Map<String, dynamic> json) => MFolder(
    id: json["id"],
    parentFolderId: json["parentFolderId"],
    fileName: json["fileName"],
    categoryId: json["categoryId"],
    textToShow: json["textToShow"],
    textToSay: json["textToSay"],
    relationId: json["relationId"],
    isVisible: json["isVisible"],
    isUnderstood: json["isUnderstood"],
    backgroundColor: json["backgroundColor"],
    minColumn: json["minColumn"],
    maxColumn: json["maxColumn"],
    minLevelToShow: json["minLevelToShow"],
    userCreated: json["userCreated"],
    isAvailable: json["isAvailable"],
    useAsset: json["useAsset"],
    localFileName: json["localFileName"],
    user: json["user"],
  );






}