
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart'  as firebase_core;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spike_firebase/herpers/helper_file.dart';
import 'package:spike_firebase/herpers/helper_toas.dart';
import 'package:spike_firebase/models/Mfolder.dart';
import 'package:spike_firebase/models/Mobject.dart';

class HelperFirebase{
   static const String carpertaRaiz   = "uploads";
   static const String carpetaImagenes= "Images";
   static const String capetaFolders  ="folder";
  String userName;
  String tipo;
  String userEmail;
  firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;

  HelperFirebase(this.userEmail,this.userName, this.tipo);


  Future<String> uploadFile(MObject folder) async {

    String  nombreArchivo="${folder.textToSay}-${folder.id}";
    File file = File(folder.fileName);
 try {
      String rutaFirebase= 'uploads/$userEmail/$tipo/$nombreArchivo';
      await firebase_storage.FirebaseStorage.instance.ref(rutaFirebase).putFile(file);
      String link = await firebase_storage.FirebaseStorage.instance.ref(rutaFirebase).getDownloadURL();
      return link ;
    } on firebase_core.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return "";
    }
  }
  Future<void> eliminarArchivosPorUsuario()async{

    HelperToast.showToast("eliminando archivos de $userEmail");
    await eliminarArchivos(capetaFolders);
    await eliminarArchivos(carpetaImagenes);
    HelperToast.showToast("eliminado correctamente");
  }


   Future <void> eliminarArchivos( String tipo)async {

    firebase_storage.ListResult result = await firebase_storage.FirebaseStorage.instance.ref("/uploads/$userEmail/$tipo").listAll();
    for (firebase_storage.Reference ref in result.items) {
      await ref.delete();
    }

  }


  Future <File?> DowloadFile(String link)async {
    String nombreArchivo="";
    String rutaArchivo="";
    try {
      nombreArchivo=link.split('/').last;
      rutaArchivo= join(HelPerFile.directorioArchivo,nombreArchivo);
      File downloadToFile = File(rutaArchivo);


     await firebase_storage.FirebaseStorage.instance.refFromURL(link).writeToFile(downloadToFile);
     return downloadToFile;

    } on firebase_core.FirebaseException catch (e) {
      HelperToast.showToast("fallo la descarga del archivo $nombreArchivo");
      return null;
    }catch (e) {
      HelperToast.showToast("error en la descarga  $nombreArchivo");
     return null ;
    }
  }


}


