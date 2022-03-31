

import 'dart:io';



import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';




class CustomImagePiker extends StatelessWidget{
 final  Function actualizarEstado ;
 final piker= ImagePicker();
 final  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  File? imagen;

   CustomImagePiker({ required this.actualizarEstado,Key? key}) : super(key: key);

 Future selImagen(op,BuildContext context) async{
   PickedFile? pikedFile;



   if(op==1){
     pikedFile= await piker.getImage(source: ImageSource.camera);


   }else{
     pikedFile= await piker.getImage(source: ImageSource.gallery);

   }
   actualizarEstado(pikedFile);


   Navigator.of(context).pop();
 }
 opciones(BuildContext context){
   showDialog(context: context, builder:(BuildContext buildContext){
     return AlertDialog(
       contentPadding: EdgeInsets.all(0),
       content: SingleChildScrollView(
         child: Column(
           children: [
             InkWell(
               onTap: (){
                 selImagen(1,context);
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
                 selImagen(2,context);
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


    // TODO: implement build
    Widget build(BuildContext context) {
      return Padding(padding: EdgeInsets.all(20),
          child:Column(
            children: [
              ElevatedButton(onPressed: (){
                opciones(context);
              },
                  child: const Text("selecciona una imagen")
              )
              ,

            ],
          )
      );

    }


}




