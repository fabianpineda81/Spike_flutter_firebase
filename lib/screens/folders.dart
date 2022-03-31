

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:spike_firebase/herpers/helper_toas.dart';
import 'package:spike_firebase/herpers/helper_web_service.dart';
import 'package:spike_firebase/models/MRelations.dart';
import 'package:spike_firebase/models/Mfolder.dart';
import 'package:spike_firebase/widgets/custom_floating_actions.dart';

import '../theme/app_theme.dart';

class Folders extends StatefulWidget {
  const Folders({Key? key}) : super(key: key);

  @override
  State<Folders> createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
  List<MFolder> folders=[];
  void openFolder(BuildContext context){
    Navigator.pushNamed(context, "forms",arguments: -1);
  }
  void openReestore(BuildContext context){
    Navigator.pushNamed(context, "reestore",arguments: -1);
  }

  void cargarFolders() async{
     folders= await MRelation.getFolderInFolder(-1);
      setState(() {

      });
    // HelperToast.showToast('${folders.length} folderes');

  }

  void backup(BuildContext context)async{
    await HelperWebService.backUpTraslations();
    HelperToast.showToast("traducciones completadas");
    await HelperWebService.backUpRelation();
    HelperToast.showToast("Relations completados");

    await HelperWebService.backUpFolders();
    HelperToast.showToast("folderes completados");

    await HelperWebService.backUpImages();
    HelperToast.showToast("imagenes completados");

    HelperToast.showToast("Termino la subida de Images");
  }


   // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return   Scaffold(
      appBar: AppBar(
        title: const Text("Folders"),
        leading: IconButton(
          icon:const Icon(Icons.settings),
          onPressed: (){
            openReestore(context);
          },
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => ListTile(
            leading: const Icon(Icons.folder,color: AppTheme.primary),
            title: Text(folders[index].textToSay),
            onTap:(){
              // final  route=MaterialPageRoute(builder: (context) => const ListView1Screen());
              //  Navigator.push(context, route);
              Navigator.pushNamed(context, "folder",arguments: folders[index]);
              //Navigator.pushReplacementNamed(context, AppRoutes.menuOptions[index].route);
            },
          ),
          separatorBuilder:(_,__)=>const Divider(),
          itemCount: folders.length
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:CustomFloatingActions(fnButton1: openFolder,fnButton2: cargarFolders,fnButton3: backup) ,
    ) ;
  }
}

