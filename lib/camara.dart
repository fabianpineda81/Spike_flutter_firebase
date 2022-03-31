

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart'  as firebase_core;
import 'package:path_provider/path_provider.dart';



class Imagen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> _imagenState();


}

class _imagenState extends State<Imagen>
{
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  File? imagen;
  final piker= ImagePicker();


  Future<void> uploadExample(String url) async {

    Directory appDocDir = await getApplicationDocumentsDirectory();

    String filePath = '$url';
    // ...
    await uploadFile(filePath);
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);


    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/file-to-upload.png')
          .putFile(file);
     String link = await firebase_storage.FirebaseStorage.instance.ref("uploads/file-to-upload.png").getDownloadURL();
     print(link);
    } on firebase_core.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }


  Future selImagen(op) async{
    PickedFile? pikedFile;
    if(op==1){
      pikedFile= await piker.getImage(source: ImageSource.camera);
    }else{
      pikedFile= await piker.getImage(source: ImageSource.gallery);

    }
    setState(() {
      if(pikedFile!=null){
        imagen= File(pikedFile.path); 
        uploadExample(pikedFile.path);
      }else{

      }

    });
    Navigator.of(context).pop();
  }


opciones(context){
  showDialog(context: context, builder:(BuildContext buildContext){
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  selImagen(1);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1,color: Colors.grey)),

                  ),
                  child: Row(
                    children: const [
                      Expanded(child: Text("Tomar una foto",style: TextStyle(
                        fontSize: 16,

                      ),
                      ),

                      ),
                      Icon(Icons.camera_alt,color: Colors.blue,)
                    ],
                  ),
                ),

              ),
              InkWell(
                onTap: (){
                  selImagen(2);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(


                  ),
                  child: Row(
                    children: const [
                      Expanded(child: Text("debe seleccionar una foto",style: TextStyle(
                        fontSize: 16,

                      ),
                      ),

                      ),
                      Icon(Icons.image,color: Colors.blue,)
                    ],
                  ),
                ),

              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                  color: Colors.red

                  ),
                  child: Row(
                    children: const [
                      Expanded(child: Text("canceler",
                        style: TextStyle(
                        fontSize: 16,
                        color: Colors.white

                      ),
                        textAlign: TextAlign.center
                        ,
                      ),

                      ),

                    ],
                  ),
                ),

              ),


            ],
          ),
      ),
    );
  } 
  
  );
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Tomando imagenes"),
      ),
      body: ListView(
        children:  [
          Padding(padding: EdgeInsets.all(20),
          child:Column(
            children: [
              ElevatedButton(onPressed: (){
                    opciones(context);
              },
                  child: const Text("selecciona una imagen")
              )
              , const SizedBox(height: 30,),
              imagen==null ?  const Center():Image.file(imagen!)

            ],
          )
            ,) ,

        ],
      ),
    );
  }


}