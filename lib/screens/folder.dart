

import 'package:flutter/material.dart';
import 'package:spike_firebase/herpers/helper_toas.dart';
import 'package:spike_firebase/models/MImage.dart';
import 'package:spike_firebase/models/MTraslations.dart';
import 'package:spike_firebase/models/Mfolder.dart';
import 'package:spike_firebase/widgets/custom_card_type_2.dart';

import '../models/MRelations.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_floating_actions.dart';
import '../widgets/grid_folders_hijos.dart';

class Folder extends StatefulWidget {

   Folder({Key? key}) : super(key: key);

  @override
  State<Folder> createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  MFolder? folder ;
  List<MFolder> folderesHijos=[];
  List<MImage> imagenesHijas=[];


  void openFolder(BuildContext context){
    HelperToast.showToast("id del folder ${folder!.id}");
    Navigator.pushNamed(context, "forms",arguments: folder!.id);
  }
  void openImage(BuildContext context){
    HelperToast.showToast("id del folder ${folder!.id}");
    Navigator.pushNamed(context, "formsImage",arguments: folder!.id);
  }

  buscarHijos() async {
    HelperToast.showToast("folder ${folder!.id}");
    List<MFolder> todosFolderes= await MFolder.getAll();
    List<MRelation> todosRelatiosn = await MRelation.getAll();
    List<Translation> todosTraslation= await Translation.getAll();
    folderesHijos= await MRelation.getFolderInFolder(folder!.id);
    imagenesHijas=await MRelation.getImangesInFolder(folder!.id);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
     folder =  ModalRoute.of(context)!.settings.arguments as MFolder;



    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(folder!.textToShow),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 10),
          child: Column(
            children: [
              const Text("Informacion del Folder"),
                const SizedBox(height: 20,),
                CustomCardType2(folder: folder!),
              const SizedBox(height: 20,),
              const Text("folderes hijos "),
              const SizedBox(height: 20,),
              GridFolderHijos(objetosHijos: folderesHijos,isFolder: true,),
              const SizedBox(height: 20,),
              const Text("Imagenes hijas "),
              const SizedBox(height: 20,),
              GridFolderHijos(objetosHijos: imagenesHijas,isFolder: false,),





            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:CustomFloatingActions(fnButton1:openFolder,fnButton2:buscarHijos,fnButton3: openImage) ,
    );
  }
}
