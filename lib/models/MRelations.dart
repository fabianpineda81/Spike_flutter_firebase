import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:spike_firebase/models/MImage.dart';
import 'package:spike_firebase/models/Mfolder.dart';
import 'package:spike_firebase/models/db.dart';
import 'package:spike_firebase/models/dbProvider.dart';

import 'Mobject.dart';

class MRelation {

  static const String TableName = 'relations';
  String cardType = 'image'; // type of card
  int id = -1; // entity's ID
  int parentFolderId = -1; // folder where this card belongs to
  int cardFolderId = -1; // folder ID of this card
  int cardImageId = -1; // image ID of this card
  int cardEmptyId = -1; // empty ID of this card
  int cardVideoId = -1; // video ID of this card
  int cardSoundId = -1; // sound ID of this card
  int userCreated = 0; // indicates if the user has created this relationship
  String parentFolderName = '';
  int visibleIndex = -1; // defines the objects placement in the grid
  int gridColumns =
  6; // inicated that the layout applies when using this number of columns
  String user =
      '';

  MRelation({
    int id = -1,
    int parentFolderId = -1,
    String cardType = 'image',
    int cardFolderId = -1,
    int cardImageId = -1,
    int cardEmptyId = -1,
    int cardVideoId = -1,
    int cardSoundId = -1,
    int userCreated = 0,
    int visibleIndex = -1,
    String user = '',
    int gridColumns = 6,
  }) {
    this.id = id;
    this.parentFolderId = parentFolderId;
    this.cardType = cardType;
    this.cardFolderId = cardFolderId;
    this.cardImageId = cardImageId;
    this.cardEmptyId = cardEmptyId;
    this.cardVideoId = cardVideoId;
    this.cardSoundId = cardSoundId;
    this.userCreated = userCreated;
    this.visibleIndex = visibleIndex;
    this.gridColumns = gridColumns;
    this.user = user ;
  }

  factory MRelation.fromMap(Map<String, dynamic> json) => MRelation(
        id: json["id"],
        parentFolderId: json["parentFolderId"],
        cardType: json["cardType"],
        cardFolderId: json["cardFolderId"],
        cardImageId: json["cardImageId"],
        userCreated: json["userCreated"]??'',
        visibleIndex: json["visibleIndex"]??'',
        gridColumns: json["gridColumns"]??'',
        user: json["user"]??'',

      );

  factory MRelation.jsonToRelation(Map<String, dynamic> json) => MRelation(
    id: json["idInDevice"],
    parentFolderId: json["parentFolderId"],
    cardType: json["cardType"],
    cardFolderId: json["cardFolderId"],
    cardImageId: json["cardImageId"],
    userCreated: json["userCreated"]??'',
    visibleIndex: json["visibleIndex"]??'',
    gridColumns: json["gridColumns"]??'',
    user: json["user"]??'',

  );
  static String createTableScript = "CREATE TABLE IF NOT EXISTS $TableName ("
      "id INTEGER PRIMARY KEY,"
      "parentFolderId INTEGER,"
      "visibleIndex INTEGER,"
      "gridColumns INTEGER,"
      "cardType TEXT,"
      "cardFolderId INTEGER,"
      "cardEmptyId INTEGER,"
      "cardImageId INTEGER,"
      "cardVideoId INTEGER,"
      "cardSoundId INTEGER,"
      "userCreated INTEGER,"
      "user TEXT"
      ")";
// Indicates to what user the folder,image, video or sound belongs to
  Map<String, dynamic> toMap() => {
    "id": id,
    "parentFolderId": parentFolderId,
    "cardType": cardType,
    "cardFolderId": cardFolderId,
    "cardImageId": cardImageId,
    "cardEmptyId": cardEmptyId,
    "cardVideoId": cardVideoId,
    "cardSoundId": cardSoundId,
    "userCreated": userCreated,
    "visibleIndex": visibleIndex,
    "gridColumns": gridColumns,
    "user": user,
  };

  static Future<void> createTableIFNotExists() async {
    final db = await DBProvider.db.database;
    await db?.rawQuery(createTableScript);
  }


  static Future<void> backup({required String userEmail, required String userName}) async {

    List<MRelation> objects = await getAll();

    //String jsonEntity = jsonEncode(objects);
    String json = jsonEncode({
      "email": userEmail,
      "name": userName,
      "operation": "upload MRelation list",
      "objects": objects,
    });


  }

  static Future<List<MRelation>> getAll() async {
    final db = await DBProvider.db.database;
    final List<Map<String, Object?>> result = await db!.query(TableName);
    List<MRelation>? list = result.isNotEmpty ? result.toList().map((c) => MRelation.fromMap(c)).toList()
        : <MRelation>[];

    return list;
  }
  static Future<List<MRelation>> getForId(int id ) async {
    final db = await DBProvider.db.database;
    final List<Map<String, Object?>> result = await db!.query(TableName,where: "id=?",whereArgs: [id]);
    List<MRelation>? list = result.isNotEmpty ? result.toList().map((c) => MRelation.fromMap(c)).toList()
        : <MRelation>[];

    return list;
  }

  static Future<int> maxId() async {
    int i = UniqueKey().hashCode;

    return i ;
  }

  static Future<void> createWithID(MRelation entity) async {
    final db = await DBProvider.db.database;
    // var res = await db.insert("$TableName", entity.toMap());
    // return res;

    await db?.rawInsert(
        "INSERT Into $TableName ("
            "id, parentFolderId,cardType,cardFolderId,cardImageId,cardEmptyId,cardVideoId,cardSoundId, userCreated, visibleIndex,gridColumns,user)"
            " VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
        [
          entity.id,
          entity.parentFolderId,
          entity.cardType,
          entity.cardFolderId,
          entity.cardImageId,
          entity.cardEmptyId,
          entity.cardVideoId,
          entity.cardSoundId,
          entity.userCreated,
          entity.visibleIndex,
          entity.gridColumns,
          entity.user,
        ]);


  }

  static Future<List<MFolder>> getFolderInFolder(int parentFolderId) async {
    final db = await DBProvider.db.database;
    String sql = 'SELECT $TableName.* '
         'FROM $TableName '
         'WHERE parentFolderId = $parentFolderId '
          'and  cardFolderId <> -1'
        ;
     var result = await db?.rawQuery(sql);
     List<MRelation>? list = result!.isNotEmpty ? result.toList().map((c) => MRelation.fromMap(c)).toList() : [];
    List<MFolder> resultForder =await getFoldersForRelations(list);
     return resultForder;


  }



  static Future<List<MFolder>> getFoldersForRelations(List<MRelation> relations) async {
    List<MFolder> folders=[] ;
    for(MRelation relation in relations){
      MFolder? folder= await MFolder.getByID(relation.cardFolderId);
      if(folder!=null){
        folders.add(folder);
      }

    }
    return folders;

  }

  static Future<List<MImage>> getImangesInFolder(int parentFolderId) async {
    final db = await DBProvider.db.database;
    String sql = 'SELECT $TableName.* '
        'FROM $TableName '
        'WHERE parentFolderId = $parentFolderId '
        'and  cardImageId <> -1'
    ;
    var result = await db?.rawQuery(sql);
    List<MRelation>? list = result!.isNotEmpty
        ? result.toList().map((c) => MRelation.fromMap(c)).toList()
        : [];
     List<MImage> resultImages= await getImagesForRelations(list);
    return resultImages;


  }

  static Future<List<MImage>> getImagesForRelations(List<MRelation> relations) async {
    List<MImage> folders=[] ;
    for(MRelation reltion in relations){
      MImage? image= await MImage.getByID(reltion.cardImageId);
      folders.add(image!);
    }
    return folders;

  }

  Map toJson() {
    return toMap();
  }

  static Future<List<MObject>> getObjectsInFolder(
      int gridColumns, int parentFolderId) async {


    List<MObject> result = <MObject>[];






    List<MRelation>  relations = await getInFolder(gridColumns, parentFolderId);

    //var r = relations.where((f) => f.parentFolderId == parentFolderId).toList();
    for (int i = 0; i < relations.length; i++) {
      MRelation mRelation = relations[i];



      if (mRelation.cardType == 'image') {
        //MImage.clearMemoryTables();
        //MImage mImage = MImage.inMemoryDictionary[mRelation.cardImageId];
        MImage? mImage = await MImage.getByID(mRelation.cardImageId);
        if (mImage != null) {
          mImage.relationId = mRelation.id;
          mImage.visibleIndex = mRelation.visibleIndex;
          result.add(mImage);
        }
      }

      if (mRelation.cardType == 'folder') {
        MFolder? mFolder = await MFolder.getByID(mRelation.cardFolderId);
        if (mFolder != null) {
          if (mFolder.id != -1) {
            mFolder.relationId = mRelation.id;
            mFolder.visibleIndex = mRelation.visibleIndex;
            result.add(mFolder);
          }
        }
      }

    }

    return result;
  }

  static Future<List<MRelation>> getInFolder(
      int gridColumns, int parentFolderId) async {



     final db = await DBProvider.db.database;
     String sql = 'SELECT $TableName.* '
         'FROM $TableName '
         'WHERE parentFolderId = $parentFolderId '
         'ORDER BY visibleIndex';
     var result = await db!.rawQuery(sql);
     List<MRelation> list = result.isNotEmpty ? result.toList().map((c) => MRelation.fromMap(c)).toList() : <MRelation>[];



    return list;
  }


  static Future<List<MRelation>> getAllRelationsOfItemId(
      String typeOfConcept, int itemId) async {
    final db = await DBProvider.db.database;
    String sql = 'SELECT $TableName.* '
        'FROM $TableName '
        'WHERE cardType = "$typeOfConcept" ';

    if (typeOfConcept == 'image') {
      sql += ' AND cardImageId = $itemId';
    }
    if (typeOfConcept == 'folder') {
      sql += ' AND cardFolderId = $itemId';
    }
    if (typeOfConcept == 'video') {
      sql += ' AND cardVideoId = $itemId';
    }
    if (typeOfConcept == 'sound') {
      sql += ' AND cardSoundId = $itemId';
    }
    if (typeOfConcept == 'empty') {
      sql += ' AND cardEmptyId = $itemId';
    }

    var result = await db?.rawQuery(sql);
    List<MRelation> list = result!.isNotEmpty
        ? result.toList().map((c) => MRelation.fromMap(c)).toList()
        : <MRelation>[];

    for (int i = 0; i < list.length; i++) {
      int parentFolderId = list[i].parentFolderId;
      if (parentFolderId == -1)
        list[i].parentFolderName = '/';
      else {
        MFolder? mFolder = await MFolder.getByID(parentFolderId);
        if (mFolder != null)
          list[i].parentFolderName = mFolder.textToShow;
        else
          list[i].parentFolderName = '';
      }
    }

    return list;
  }
  static Future<void> delete(MRelation mobject) async {
    final db = await DBProvider.db.database;
    await db!.rawQuery("delete from $TableName WHERE id=${mobject.id}");


  }








}
