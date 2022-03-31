import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spike_firebase/models/Mfolder.dart';
import 'package:spike_firebase/models/Mobject.dart';
import 'package:spike_firebase/widgets/custom_card_type_2.dart';
import 'package:spike_firebase/widgets/custom_grid_folder_card_.dart';

import '../theme/app_theme.dart';

class GridFolderHijos extends StatelessWidget {
   List<MObject> objetosHijos=[];
   final bool isFolder;
  GridFolderHijos({Key? key,required this.objetosHijos,required this.isFolder}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return SizedBox(
      height: 250,
      child:  GridView.count(crossAxisCount: 2,
      children: List.generate(objetosHijos.length, (index)  {
        return CustomGridFolderCard(folder: objetosHijos[index],isFolder:isFolder ,);
          }
          ,)
      ),
    );


  }





}

