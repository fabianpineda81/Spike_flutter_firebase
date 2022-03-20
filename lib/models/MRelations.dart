import 'dart:convert';

import 'package:spike_firebase/models/db.dart';
import 'package:spike_firebase/models/dbProvider.dart';

class MRelation {

  static const String TableName = 'relations';
  String cardType; // type of card
  int id; // entity's ID
  int parentFolderId; // folder where this card belongs to
  int cardFolderId; // folder ID of this card
  int cardImageId; // image ID of this card
  int cardEmptyId; // empty ID of this card
  int cardVideoId; // video ID of this card
  int cardSoundId; // sound ID of this card
  int userCreated; // indicates if the user has created this relationship
  String parentFolderName='';
  int visibleIndex; // defines the objects placement in the grid
  int gridColumns; // inicated that the layout applies when using this number of columns
  String user;

  MRelation(
      {required this.cardType,
      required this.id,
      required this.parentFolderId,
      required this.cardFolderId,
      required this.cardImageId,
      required this.cardEmptyId,
      required this.cardVideoId,
      required this.cardSoundId,
      required this.userCreated,

      required this.visibleIndex,
      required this.gridColumns,
      required this.user});

  factory MRelation.fromMap(Map<String, dynamic> json) => MRelation(
        id: json["id"],
        parentFolderId: json["parentFolderId"],
        cardType: json["cardType"],
        cardFolderId: json["cardFolderId"],
        cardImageId: json["cardImageId"],
        cardEmptyId: json["cardEmptyId"],
        cardVideoId: json["cardVideoId"],
        cardSoundId: json["cardSoundId"],
        userCreated: json["userCreated"],
        visibleIndex: json["visibleIndex"],
        gridColumns: json["gridColumns"],
        user: json["user"],

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




}
