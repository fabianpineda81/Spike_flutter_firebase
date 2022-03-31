

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spike_firebase/models/Mfolder.dart';

import '../theme/app_theme.dart';

class CustomCardType2 extends StatelessWidget {
  final  MFolder folder;
  const CustomCardType2({Key? key ,required this.folder}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return Card(
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
              width: double.infinity,
              height: 230,
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
    );
  }
}
