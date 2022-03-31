import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:spike_firebase/herpers/helper_toas.dart';
import 'package:spike_firebase/models/Mobject.dart';


import 'MTraslations.dart';
import 'dbProvider.dart';

class MFolder extends MObject{
  static const String TableName = 'folders';
  // se agrego el textToshow y text to Say
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
      "user TEXT,"
      "textToShow TEXT,"
      "textToSay TEXT"

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
      this.fileName = 'assets/Images/folders_folder.png';
    }

    if (this.fileName.isEmpty) {
      this.fileName = 'assets/Images/folders_folder.png';
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
        "INSERT Into $TableName (id,parentFolderId,fileName,categoryId, isVisible, isUnderstood, userCreated, isAvailable, useAsset, localFileName,user,backgroundColor,textToShow,textToSay) "
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
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
          entity.textToShow,
          entity.textToSay,

        ]);



  }
  static Future<void> update(MFolder entity) async {
    final db = await DBProvider.db.database;
    await db?.update(TableName, entity.toBDMap(),
        where: "id = ?", whereArgs: [entity.id]);


  }
  static Future<void> updateId({required int idFolder,required int newId}) async {
    final db = await DBProvider.db.database;
     int? res= await db?.update(TableName, {"id":newId},
        where: "id = ?", whereArgs: [idFolder]);
     HelperToast.showToast(res.toString());


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
    int i = UniqueKey().hashCode;

    return i ;
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





    //String jsonEntity = jsonEncode(objects);
    String json = jsonEncode({
      "email": userEmail,
      "name": userName,
      "operation": "upload MFolder list",
     // "objects": folders,
    });

  }

  static Future<MFolder?> getByID(int id) async {
    /*final db = await DBProvider.db.database;
    final List<Map<String, Object?>> result = await db!.query(TableName,where: "id=?",whereArgs: [id]);
    List<MFolder>? list = result.isNotEmpty ? result.toList().map((c) => MFolder.fromMap(c)).toList()
        : <MFolder>[];
      try{
        return list.first;
      }catch(e){
        return null;
      }*/
    String languageCode ="en";
   // await LocalPreferences.getString('languageCode', 'en');
    String sql = 'SELECT $TableName.*, '
        '${Translation.TableName}.textToShow, ${Translation.TableName}.textToSay '
    //'${MCategory.TableName}.backgroundColor, ${MCategory.TableName}.minColumn, '
    // '${MCategory.TableName}.minColumn, '
    // '${MCategory.TableName}.maxColumn '
    //'${MCategory.TableName}.maxColumn, ${MCategory.TableName}.minLevelToShow '

        'FROM $TableName '
        'LEFT JOIN ${Translation.TableName} '
        'ON ${Translation.TableName}.language="$languageCode" '
        'AND ${Translation.TableName}.tableName="${MFolder.TableName}" '
        'AND ${Translation.TableName}.itemId=$TableName.id '
        'WHERE $TableName.id = $id '
        'ORDER BY ${Translation.TableName}.textToShow';

    final db = await DBProvider.db.database;
    final List<Map<String, Object?>> result = await db!.rawQuery(sql);
    List<MFolder>? list = result.isNotEmpty ? result.toList().map((c) => MFolder.fromMap(c)).toList()
        : <MFolder>[];
    try{
      return list.first;
    }catch(e){
      return null;
    }




  }
  static Future<List<MFolder>> getAll() async {
   /* final db = await DBProvider.db.database;
    final List<Map<String, Object?>> result = await db!.query(TableName);
    List<MFolder>? list = result.isNotEmpty ? result.toList().map((c) => MFolder.fromMap(c)).toList()
        : <MFolder>[];*/
    String languageCode ="en";

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
        'AND ${Translation.TableName}.tableName="${MFolder.TableName}" '
        'AND ${Translation.TableName}.itemId=$TableName.id '
        'ORDER BY ${Translation.TableName}.textToShow';
    // 'LEFT JOIN ${MCategory.TableName} '
    // 'ON ${MCategory.TableName}.id=$TableName.categoryId ';
    var result = await db?.rawQuery(sql);
    List<MFolder> list = result!.isNotEmpty
        ? result.toList().map((c) {
      //int id = c["id"];
      return MFolder.fromMap(c);
    }).toList()
    // ? result.toList().map((c) =>
    //     MFolder.fromMap(c)
    //   ).toList()
        : <MFolder>[];

    return list;
  }

  factory MFolder.fromMap(Map<String, dynamic> json) => MFolder(

    id: json["id"],
    parentFolderId: json["parentFolderId"],
    fileName: json["fileName"]??'',
    categoryId: json["categoryId"]??-1,
    textToShow: json["textToShow"]??'',
    textToSay: json["textToSay"]??'',
    isVisible: json["isVisible"]??1,
    isUnderstood: json["isUnderstood"]??1,
    backgroundColor: json["backgroundColor"]??'',
    //minColumn: json["minColumn"],
    //maxColumn: json["maxColumn"],
    minLevelToShow: json["minLevelToShow"]??1,
    userCreated: json["userCreated"]??1,
    isAvailable: json["isAvailable"]??1,
    useAsset: json["useAsset"]??'',
    localFileName: json["localFileName"]??'',
    user: json["user"]??'',


  );
  factory MFolder.jsonToFolder(Map<String, dynamic> json) => MFolder(
    id: json["idInDevice"],
    parentFolderId: json["parentFolderId"],
    fileName: json["fileName"]??'',
    categoryId: json["categoryId"]??-1,
    textToShow: json["textToShow"]??'',
    textToSay: json["textToSay"]??'',
    isVisible: json["isVisible"]??1,
    isUnderstood: json["isUnderstood"]??1,
    backgroundColor: json["backgroundColor"]??'',
    //minColumn: json["minColumn"],
    //maxColumn: json["maxColumn"],
    minLevelToShow: json["minLevelToShow"]??1,
    userCreated: json["userCreated"]??1,
    isAvailable: json["isAvailable"]??1,
    useAsset: json["useAsset"]??1,
    localFileName: json["localFileName"]??'',
    user: json["user"]??'',


  );
  Map toJson() {
    return toBDMap();
  }










}