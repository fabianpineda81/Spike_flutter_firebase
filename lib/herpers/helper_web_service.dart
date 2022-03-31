import 'dart:convert';
import 'dart:io';


import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:spike_firebase/herpers/helper_firebase.dart';
import 'package:spike_firebase/herpers/helper_toas.dart';
import 'package:spike_firebase/models/MImage.dart';
import 'package:spike_firebase/models/MRelations.dart';
import 'package:spike_firebase/models/MTraslations.dart';

import '../models/Mfolder.dart';
import '../models/Mobject.dart';
import '../models/helper.dart';

class HelperWebService {
  static String baseUrl =
      'https://container-service-1.0n1v1jgsd67bu.us-east-1.cs.amazonlightsail.com';
  static String userEmail = "fabianpineda81@gmail.com";
  static String userName = "fabian pineda";

  static Future<void> backUpFolders() async {
    List<MFolder> folders = await MFolder.getAll();
    HelperFirebase firebase =
        HelperFirebase(userEmail, userName, HelperFirebase.capetaFolders);
    // este metodo hay pasarlo al metodo que hace el backup total por ahora esta aca
    await firebase.eliminarArchivosPorUsuario();

    // se monta la imagen a firebase y se actualiza el link
    for (int i = 0; i < folders.length; i++) {
      String link = await firebase.uploadFile(folders[i]);
      folders[i].fileName = link;
      HelperToast.showToast("se monto la imagen de ${folders[i].textToShow}");
    }

    String json = jsonEncode({
      "email": userEmail,
      "name": userName,
      "operation": "upload folders",
      "objects": folders,
    });
    String res = await invokeWebService(json, "backup/v1/uploadMfolderList");
    HelperToast.showToast(res);
  }

  static Future<void> backUpImages() async {
    List<MImage> images = await MImage.getAll();
    HelperFirebase firebase =
        HelperFirebase(userEmail, userName, HelperFirebase.carpetaImagenes);

    // se monta la imagen a firebase y se actualiza el link
    for (int i = 0; i < images.length; i++) {
      String link = await firebase.uploadFile(images[i]);
      images[i].fileName = link;
      HelperToast.showToast("se monto la imagen de ${images[i].textToShow}");
    }

    String json = jsonEncode({
      "email": userEmail,
      "name": userName,
      "operation": "upload folders",
      "objects": images,
    });

    String res = await invokeWebService(json, "backup/v1/uploadMimageList");
    HelperToast.showToast(res);
  }
  static Future<void> backUpRelation() async {
    List<MRelation> relations = await MRelation.getAll();


    // se monta la imagen a firebase y se actualiza el link


    String json = jsonEncode({
      "email": userEmail,
      "name": userName,
      "operation": "upload relations",
      "objects": relations,
    });
    String res = await invokeWebService(json, "backup/v1/uploadMRelationList");
    HelperToast.showToast(res);
  }

  static Future<void> backUpTraslations() async {
    List<Translation> traslations = await Translation.getAll();


    // se monta la imagen a firebase y se actualiza el link


    String json = jsonEncode({
      "email": userEmail,
      "name": userName,
      "operation": "upload translation",
      "objects": traslations,
    });
    String res = await invokeWebService(json, "backup/v1/uploadMTranslationList");
    HelperToast.showToast(res);
  }

  static Future<dynamic> invokeWebService(String jsonString, String operacion) async {
    try {
      // set up POST request arguments

      Map<String, String> headers = {"Content-type": "application/json"};
      String finalUrl = "$baseUrl/$operacion";
      // make POST request
      http.Response response = await http.post(Uri.parse(finalUrl),
          headers: headers, body: jsonString);

      // check the status code for the result
      int statusCode = response.statusCode;

      if (statusCode == 200) {
        Map<String, dynamic> res = jsonDecode(response.body);
        return res["message"];
      }
      if (statusCode > 400 && statusCode < 500) {
        Map<String, dynamic> res = jsonDecode(response.body);
        return res["message"];
      }
      if(statusCode == 500){
        Map<String, dynamic> res = jsonDecode(response.body);
        return res["message"];
      }

      throw Exception('Failed to execute operation. Error $statusCode');
    } catch (err) {
      return err.toString();
    }
  }

  static Future <List<dynamic>> listRemoteFolders(String userEmail1){
    String operacion = "operations/v1/listFoldersOfAUser?email=$userEmail&language=es";
    return invokeWebServiceGet(operacion);
  }

  static Future<List<dynamic>> invokeWebServiceGet(String operacion) async{
    // esto siempre tiene que devolcer una lista de objetos o un error

      // set up POST request arguments

      Map<String, String> headers = {"Content-type": "application/json"};
    String linkFinal = "$baseUrl/$operacion";
      // make POST request
      http.Response response = await http.get(Uri.parse(linkFinal),headers: headers);

      // check the status code for the result
      int statusCode = response.statusCode;

      if (statusCode == 200) {
        Map<String, dynamic> res = jsonDecode(response.body);

        return res["message"];
      }
      if (statusCode > 400 && statusCode < 500) {
        Map<String, dynamic> res = jsonDecode(response.body);

        throw Exception("${res['message']} $statusCode");
      }

      throw Exception('Failed to execute operation. Error $statusCode');
    }

  static Future<Map<String, dynamic>> invokeWebServiceGetFolders(String operacion) async{
    // esto siempre tiene que devolcer una lista de objetos o un error

    // set up POST request arguments

    Map<String, String> headers = {"Content-type": "application/json"};
    String linkFinal = "$baseUrl/$operacion";
    // make POST request
    http.Response response = await http.get(Uri.parse(linkFinal),headers: headers);

    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.body);

      return res;
    }
    if (statusCode > 400 && statusCode < 500) {
      Map<String, dynamic> res = jsonDecode(response.body);

      return res ;
    }

    throw Exception('Failed to execute operation. Error $statusCode');
  }





  static Future<void> replaceFolder(String userEmailNameToRestore, int selectedFolderToRestore, int selectedLocalFolder) async {

    MFolder? localFolder = await MFolder.getByID(selectedLocalFolder);
    if (localFolder == null) {
      if(selectedLocalFolder==-1){
        localFolder= MFolder();
      }else{
        HelperToast.showToast("error no se encontro el folder local ");
        return;
      }


    }


     List<Translation>  remoteTranslations=await findARemoteTraslations(localFolder, selectedFolderToRestore);
     List<MRelation> remoteRelations= await findRemoteRelations(selectedFolderToRestore);

     for (MRelation r in remoteRelations){
       MRelation.createWithID(r);
     }
     for (Translation t in remoteTranslations){
      await Translation.create(t);
     }

    List<MObject> objectsToDelete = await MRelation.getObjectsInFolder(6, selectedLocalFolder);

    await findRemoteImages(selectedFolderToRestore: selectedFolderToRestore, remoteTranslations: remoteTranslations, localFolder: localFolder, remoteRelations: remoteRelations);
    await findRemoteFolders(selectedFolderToRestore: selectedFolderToRestore, remoteTranslations: remoteTranslations, localFolder: localFolder, remoteRelations: remoteRelations);



















    // add videos



    // add sounds



    // add folders
    //dynamic remoteFolders = webResponseDynamic.content[4];



    /*final lucasState =
        PropertyChangeProvider.of<LucasState>(context, listen: false).value;
    int gridColumns = lucasState.getGridColumns();
    List<MObject> objects =
    await MRelation.getObjectsInFolder(gridColumns, localFolder.id);
    await lucasState.saveObject(StateProperties.gridObjects, objects);

    if (mounted) {
      setState(() {
        isRestoring = false;
        status = "";
        status = translations['operation completed successfully'];
      });
    }

    showSnackbar("operation completed successfully",
        Duration(milliseconds: 900));*/
    HelperToast.showToast("tarea completada");
  }


// esto
  static Future<void> addRemoteImage(MImage image, List<Translation> remoteObjectTranslations, List<MRelation> remoteRelations, MFolder parentFolder) async {
    MImage mImage = MImage(
      id: image.id,
      fileName: image.fileName,
      isVisible: image.isVisible,
      isUnderstood: image.isUnderstood!,
      useAsset: image.useAsset,
      localFileName: image.localFileName,
      userCreated: image.userCreated,
      isAvailable: image.isAvailable!,
      backgroundColor:image.backgroundColor!,
      minLevelToShow: image.minLevelToShow,
    );
    HelperFirebase helperFirebase = HelperFirebase(userEmail, userName, HelperFirebase.carpetaImagenes);
    File? file=  await helperFirebase.DowloadFile(mImage.fileName);
    if(file != null){
      mImage.fileName=file.path;
    }

    await MImage.createWithID(mImage);


    // add translation
    for (var t in remoteObjectTranslations) {
      if (t.tableName == MImage.TableName && t.itemId== image.id) {
         Translation entity = Translation(
          tableName: MImage.TableName,
          itemId: mImage.id,
          language: t.language,
          textToShow: t.textToShow,
          textToSay: t.textToSay,
          user: ''
        );

        await Translation.create(entity);
      }
    }

    // Add relation
    int visibleIndex = -1;
    int userCreated = 1;




  }

  static Future<void> addRemoteFolder(MFolder nFolder) async {


  /*  MFolder nFolder = MFolder(
      id: folder.id,
      fileName:folder.fileName ,
      isVisible: folder.isVisible,
      isUnderstood: folder.isUnderstood!,
      useAsset: folder.useAsset,
      localFileName:folder.localFileName,
      userCreated: folder.userCreated,
      isAvailable:folder.isAvailable!,
      backgroundColor:folder.backgroundColor!,
      minLevelToShow: folder.minLevelToShow,
    );*/


    HelperFirebase helperFirebase = HelperFirebase(userEmail, userName, HelperFirebase.capetaFolders);
    File? file =  await helperFirebase.DowloadFile(nFolder.fileName);
    if(file != null){
      nFolder.fileName=file.path;
    }else{
      nFolder.fileName="assets/Images/folders_folder.png";
    }


      try {
        await MFolder.createWithID(nFolder);
      }catch(e){
      HelperToast.showToast("error folde id ${nFolder.id} " );
       print(e.toString());
       return;
      }







    // Add relation




  }

  // esta funcion devuelve una lista por si se nesecita pero ya actualiza las traducciones en la bd
  static Future<List<Translation>> findARemoteTraslations(MFolder localFolder,int selectedFolderToRestore) async {
    // peticion de las traslations
    //dynamic remoteTranslations = webResponseDynamic.content[0];
    String operacionTraslation="operations/v1/listTranslationOfObjectsOfAFoldersOfAUser?email=$userEmail&folderIdInDevice=$selectedFolderToRestore";

    List<dynamic> remoteJsonTranslations=await invokeWebServiceGet(operacionTraslation)  ;
    List<Translation> remoteTranslations= HelperBR.jsonToTranslation(remoteJsonTranslations);


    // update translations


    return remoteTranslations;
  }

  static Future<List<MRelation>> findRemoteRelations(int selectedFolderToRestore) async {
  String operacion= 'operations/v1/listRelationsOfAFoldersOfAUser?email=$userEmail&folderIdInDevice=$selectedFolderToRestore';
  List<dynamic> remoteJsonRelations=await invokeWebServiceGet(operacion);
  List<MRelation> remoteRelations=await HelperBR.jsonToRelations(remoteJsonRelations);
  return remoteRelations;

  }

  static Future<List<MImage>> findRemoteImages( {required int selectedFolderToRestore,required List<Translation> remoteTranslations,required MFolder localFolder, required List<MRelation> remoteRelations})async{
    // peticion de imagenes
    String operacionImages="operations/v1/listImagesOfAFoldersOfAUser?email=$userEmail&folderIdInDevice=$selectedFolderToRestore";
    List<dynamic>  remoteJsonImages = await invokeWebServiceGet(operacionImages)  ;
    List<MImage> remoteImages= HelperBR.jsonToImages(remoteJsonImages);

    for (var i in remoteImages) {
      await addRemoteImage(i, remoteTranslations, remoteRelations, localFolder);
    }
    return remoteImages;

  }

  static Future<List<MFolder>> findRemoteFolders( {required int selectedFolderToRestore,required List<Translation> remoteTranslations,required MFolder localFolder, required List<MRelation> remoteRelations})async{
    String operacionFolderes="operations/v1/listFoldersOfAFoldersOfAUser?email=$userEmail&folderIdInDevice=$selectedFolderToRestore";

    Map<String,dynamic> json = await invokeWebServiceGetFolders(operacionFolderes);
    dynamic jsonRoofolder= json["rootFolder"];
    dynamic remoteJsonFolders= json["message"];

    List<MFolder> remoteFolders= HelperBR.jsonToFolder(remoteJsonFolders);
    MFolder roofolder= MFolder.jsonToFolder(jsonRoofolder["folder"][0]);
    MRelation rooRelation = MRelation.jsonToRelation(jsonRoofolder["relation"][0]);


    rooRelation.parentFolderId= localFolder.id;
    //MFolder.createWithID(roofolder);
    await addRemoteFolder(roofolder);

    MRelation.createWithID(rooRelation);







    for (var i in remoteFolders) {
      await addRemoteFolder(i);
    }
    return remoteFolders;
  }




}


