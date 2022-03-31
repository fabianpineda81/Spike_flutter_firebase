

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spike_firebase/herpers/helper_file.dart';
import 'package:spike_firebase/herpers/helper_toas.dart';
import 'package:spike_firebase/models/MImage.dart';
import 'package:spike_firebase/models/dbProvider.dart';
import 'package:spike_firebase/widgets/custom_floating_actions.dart';
import 'package:spike_firebase/widgets/custom_image_piker.dart';

import '../models/MRelations.dart';
import '../models/MTraslations.dart';
import '../models/Mfolder.dart';
import '../widgets/custon_input_file.dart';

class FormImage extends StatefulWidget {
  const FormImage({Key? key}) : super(key: key);

  @override
  State<FormImage> createState() => _FormImageState();
}

class _FormImageState extends State<FormImage> {
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
        title: const Text("Agregar imagen"),
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

                await  guardarImagen();
                }, child: const Text("guardar")),


            ],
          ),
        ),
      ),


    ) ;
  }

  Future<void> guardarImagen() async {
      if(textToShow=='') return;
      if(texTosay=='') return;
      if(imagen==null) return;
      String pahtFinal = await  HelPerFile.moverImagenPermanente(imagen!);

      // creacion de la relacion
      int maxRelationId= await MRelation.maxId();
      int maxImageId= await MImage.maxId();
      MRelation entity = MRelation(id: maxRelationId, parentFolderId: parentFolderID, cardType: 'image', cardFolderId: -1, cardImageId: maxImageId, cardEmptyId: -1, visibleIndex: 1, userCreated: 1,);
      MRelation.createWithID(entity);


      // creacion de folder
       MImage image =MImage(id: maxImageId,fileName: pahtFinal,categoryId: -1,isVisible: 1,isUnderstood: 1,textToShow:textToShow,textToSay: texTosay);
       MImage.createWithID(image);
      Translation traslation = Translation(tableName: MImage.TableName, itemId: image.id, language: 'es', textToShow: textToShow, textToSay: texTosay, user: '');
      Translation traslationen = Translation(tableName: MImage.TableName, itemId: image.id, language: 'en', textToShow: textToShow, textToSay: texTosay, user: '');
      await Translation.create(traslation);
      await Translation.create(traslationen);
      HelperToast.showToast("Imagen creada correctamente");
       Navigator.pushReplacementNamed(context, "folders");

  }
}
