import 'package:spike_firebase/herpers/helper_file.dart';

import 'MImage.dart';
import 'MRelations.dart';
import 'MTraslations.dart';
import 'Mfolder.dart';
import 'Mobject.dart';

class HelperBR{
  static Future<String> deleteAnObject(MObject mObjectToDelete) async {
    String typeOfConcept = '';
    if (mObjectToDelete is MFolder) {
      typeOfConcept = 'folder';
      MFolder mFolder = mObjectToDelete;

      // Delete all objects (including subfolders)
      List<MObject> objectsToDelete =
      await MRelation.getObjectsInFolder(6, mFolder.id);

      for (var mObject in objectsToDelete) {
        String typeOfConcept = await deleteAnObject(mObject);

        List<MRelation> relations =
        await MRelation.getAllRelationsOfItemId(typeOfConcept, mObject.id);
        for (int i = 0; i < relations.length; i++) {
          await MRelation.delete(relations[i]);
        }
      }

      await MFolder.delete(mFolder);

      await Translation.deleteForObject("folders", mObjectToDelete.id);
    }
    if (mObjectToDelete is MImage) {
      typeOfConcept = 'image';
      MImage mImage = mObjectToDelete;
      await MImage.delete(mImage);

      if (mImage.useAsset == 0) {
        await HelPerFile.deleteLocalFile(mImage);
      }

      // List<MRelation> relations = await MRelation.getAllRelationsOfItemId(
      //     typeOfConcept, mObjectToDelete.id);
      // for (int i = 0; i < relations.length; i++) {
      //   await MRelation.delete(relations[i]);
      // }

      await Translation.deleteForObject("Images", mObjectToDelete.id);
    }



    return typeOfConcept;
  }
  static List<Translation> jsonToTranslation(List<dynamic> lista ){
    List<Translation> translations= [];
    for (var json in lista) {
      Translation t= Translation.fromMap(json);
      translations.add(t);
    }

    return translations;
  }
  static List<MRelation> jsonToRelations(List<dynamic> lista ){
    List<MRelation> MRelations= [];
    for (var json in lista) {
      MRelation t= MRelation.jsonToRelation(json);
      MRelations.add(t);
    }

    return MRelations;
  }

  static List<MImage> jsonToImages(List<dynamic> lista ){
    List<MImage> MImages= [];
    for (var json in lista) {
      MImage t= MImage.jsonToImage(json);
      MImages.add(t);
    }

    return MImages;
  }

  static List<MFolder> jsonToFolder(List<dynamic> lista ){
    List<MFolder> MFolders= [];
    for (var json in lista) {
      MFolder t= MFolder.jsonToFolder(json);
      MFolders.add(t);
    }

    return MFolders;
  }
}