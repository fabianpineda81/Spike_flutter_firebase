

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spike_firebase/herpers/helper_toas.dart';
import 'package:spike_firebase/models/Mfolder.dart';
import 'package:spike_firebase/models/Mobject.dart';

import '../theme/app_theme.dart';

class CustomGridFolderCard extends StatelessWidget {
  final  MObject folder;
  final bool isFolder;
  const CustomGridFolderCard({Key? key ,required this.folder,required this.isFolder}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return InkWell(
      onTap: (){
        if(isFolder){
          Navigator.pushNamed(context, "folder",arguments: folder);
        }else{
          HelperToast.showToast("Id imagen ${folder.id}");
        }

      },
      child: Card(
        clipBehavior:Clip.antiAlias ,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        ) ,
        elevation: 10,
        shadowColor: AppTheme.primary.withOpacity(0.5),



        child: Column(
          children: [
             Image(
                image: FileImage(File(folder.fileName))
                ,
                width: double.infinity/3,
                height: 100,
              fit: BoxFit.cover,
              //fadeInDuration: Duration(microseconds: 300),
            ),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              padding:const  EdgeInsets.only(
                right: 20,top: 10,bottom: 10,
              ),
              child:  Text(folder.textToShow),
            )
          ],
        ),
      ),
    );
  }
}
