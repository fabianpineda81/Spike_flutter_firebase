import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spike_firebase/herpers/helper_toas.dart';
import 'package:spike_firebase/herpers/helper_web_service.dart';

import '../models/Mfolder.dart';

class Resstore extends StatefulWidget{
  @override
  State<Resstore> createState() => _ResstoreState();
}

class _ResstoreState extends State<Resstore> {
  List<DropdownMenuItem<int>> folderesRemotos=[];
  List<DropdownMenuItem<int>> folderesLocales=[];

  int selectFolderTorestore=-1;
  int selectedLocalFolder = -1;


  @override
  void initState()  {
     itmsFoldersRemotos();
     itmsFoldersLocal();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reestore"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            const Text("Remote folder"),
            const SizedBox(height: 10,),
            DropdownButtonFormField<int>(
              items: folderesRemotos,
              onChanged: (value) {
                selectFolderTorestore= value!;
                HelperToast.showToast(value.toString());
              },

            ),
            const SizedBox(height: 10,),
            const Text("Folder local "),
            const SizedBox(height: 10,),
            DropdownButtonFormField<int>(
              items: folderesLocales,
              onChanged: (value) {
                selectedLocalFolder= value!;
                HelperToast.showToast(value.toString());
              },

            ),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed:() async {

              setState(() {

              });
            }, child: const Text("cargar informacion")

            ),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed:() async {
              HelperWebService.replaceFolder("fabianpineda81@gmail.com", selectFolderTorestore, selectedLocalFolder);
              setState(() {

              });
            }, child: const Text("Reemplazar folder")

            ),

          ],
        ),


      ),
    );
  }

Future<void> itmsFoldersLocal() async {
  List<MFolder> list  = await MFolder.getAll();
  folderesLocales=[];
  folderesLocales.add(const DropdownMenuItem(child: Text("Folder Raiz",), value:-1,));

  for (var v in list) {
    folderesLocales.add(
      DropdownMenuItem(
        child: Text(
          v.textToShow,

        ),
        value: v.id,
      ),
    );
  }

}
 Future<void> itmsFoldersRemotos()async{

dynamic resFolder= await HelperWebService.listRemoteFolders("");
   List<DropdownMenuItem<int>> items  = <DropdownMenuItem<int>>[];
   if (resFolder!= null) {
     for (var v in resFolder) {
       items.add(
         DropdownMenuItem(
           child: Text(
             v["textToShow"],
             // style: TextStyle(
             //   fontWeight: FontWeight.bold,
             // ),
           ),
           value: int.parse(v["folderIdInDevice"].toString()),
         ),
       );

     }

   }
  folderesRemotos= items;
   setState(() {

   });
  }



}


