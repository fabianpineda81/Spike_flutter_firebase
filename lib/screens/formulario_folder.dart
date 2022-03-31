

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spike_firebase/herpers/helper_file.dart';
import 'package:spike_firebase/herpers/helper_toas.dart';
import 'package:spike_firebase/models/dbProvider.dart';
import 'package:spike_firebase/widgets/custom_floating_actions.dart';
import 'package:spike_firebase/widgets/custom_image_piker.dart';

import '../models/MRelations.dart';
import '../models/MTraslations.dart';
import '../models/Mfolder.dart';
import '../widgets/custon_input_file.dart';

class FormFolder extends StatefulWidget {
  const FormFolder({Key? key}) : super(key: key);

  @override
  State<FormFolder> createState() => _FormFolderState();
}

class _FormFolderState extends State<FormFolder> {
  // This widget is the root of your application.
  String textToShow='';
  String texTosay='';
  File? imagen ;
  PickedFile? pickedFile;
  int  parentFolderID=-1;
void actualizarTextToshow(String texto){
  textToShow=texto;
  setState(() {});
}
void actualizarTextToSay(String texto){
  texTosay=texto;
  setState(() {});
}
void actualizarImagen(PickedFile file ){
  pickedFile= file;
  imagen = File(file.path) ;
  setState(() {});
}





  @override
  Widget build(BuildContext context) {
     parentFolderID =  ModalRoute.of(context)!.settings.arguments as int;
    return   Scaffold(
      appBar: AppBar(
        title: const Text("Folders"),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            children:  [
              CustomInputFile(actualizarEstado:actualizarTextToshow,autofocus: true,hintText: "text a mostrar",labelText: "Texto to show"),
              const SizedBox(height: 30,),
              CustomInputFile(actualizarEstado:actualizarTextToSay, autofocus: false,hintText: "texto a decir",labelText: "text to say",),
              const SizedBox(height: 30,),
              CustomImagePiker(actualizarEstado: actualizarImagen,),
              const SizedBox(height: 30,),
              imagen==null ?  const Center():Image.file(imagen!),
              const SizedBox(height: 30,),
              ElevatedButton(onPressed: () async {

                await  guardarFolder();
                }, child: const Text("guardar")),


            ],
          ),
        ),
      ),


    ) ;
  }

  Future<void> guardarFolder() async {
      if(textToShow=='') return;
      if(texTosay=='') return;
      if(imagen==null) return;
      String pahtFinal = await  HelPerFile.moverImagenPermanente(imagen!);

      // creacion de la relacion
      int maxRelationId= await MRelation.maxId();
      int maxFolderId= await MFolder.maxId();
      MRelation entity = MRelation(id: maxRelationId, parentFolderId: parentFolderID, cardType: 'folder', cardFolderId: maxFolderId, cardImageId: -1, cardEmptyId: -1, visibleIndex: 1, userCreated: 1,);
      MRelation.createWithID(entity);
      // creacion de folder

      MFolder folder = MFolder(id: maxFolderId,fileName: pahtFinal,categoryId: -1,isVisible: 1,textToSay: texTosay,textToShow: textToShow,relationId: maxRelationId,parentFolderId: parentFolderID);
      MFolder.createWithID(folder);

      // creaccion de traslation
      Translation traslation = Translation(tableName: MFolder.TableName, itemId: folder.id, language: 'es', textToShow: textToShow, textToSay: texTosay, user: '');
      Translation traslationen = Translation(tableName: MFolder.TableName, itemId: folder.id, language: 'en', textToShow: textToShow, textToSay: texTosay, user: '');
     await Translation.create(traslation);
      await Translation.create(traslationen);
       HelperToast.showToast("Carpeta creada correctamente");
       Navigator.pushReplacementNamed(context, "folders");

  }
}
