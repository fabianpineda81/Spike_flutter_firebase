import 'dart:convert';

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
      "user TEXT"
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
      this.fileName = 'assets/images/ui_empty.png';
    }

    if (this.fileName.isEmpty) {
      this.fileName = 'assets/images/ui_empty.png';
    }

    this.isVisible = isVisible;
    this.isUnderstood = isUnderstood;
    this.backgroundColor = backgroundColor ?? '';
    this.minColumn = minColumn ?? 1;
    this.maxColumn = maxColumn ?? 1;
    this.minLevelToShow = minLevelToShow ?? 1;
    this.useAsset = useAsset ?? 1;
    this.localFileName = localFileName ?? '';

    this.userCreated = userCreated ?? 1;
    this.isAvailable = isAvailable;
    this.user = user ?? '';
  }
  factory MImage.fromMap(Map<String, dynamic> json) => MImage(
    id: json["id"],
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
    useAsset: json["useAsset"],
    localFileName: json["localFileName"],
    userCreated: json["userCreated"],
    isAvailable: json["isAvailable"],
    user: json["user"],
  );


  static Future<void> createWithID(MImage entity) async {
    final db = await DBProvider.db.database;
    // var res = await db.insert("$TableName", entity.toMap());
    // return res;

    await db?.rawInsert(
        "INSERT Into $TableName (id,fileName,categoryId, isVisible, isUnderstood, useAsset, localFileName, userCreated,isAvailable,user,backgroundColor)"
            " VALUES (?,?,?,?,?,?,?,?,?,?,?)",
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
        ]);


  }
  static Future<void> update(MImage entity) async {
    final db = await DBProvider.db.database;
    await db?.update("$TableName", entity.toBDMap(),
        where: "id = ?", whereArgs: [entity.id]);


  }

  static Future<int> maxId() async {
    final db = await DBProvider.db.database;

    var table = await db?.rawQuery("SELECT MAX(id)+1 as id FROM $TableName");
    Object maxId = await table?.first["id"] ?? 1;

    return int.parse(maxId.toString()) ;
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





}