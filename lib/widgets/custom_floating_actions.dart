
import 'package:flutter/material.dart';

class CustomFloatingActions extends StatelessWidget{
  final Function fnButton1;
  final Function fnButton2;
  final Function fnButton3;
  const CustomFloatingActions({Key? key, required this.fnButton1, required this.fnButton2,required this.fnButton3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment:MainAxisAlignment.spaceAround,

      children:  [
        FloatingActionButton(
          child: const Icon(Icons.plus_one),
          onPressed:(){
            fnButton1(context);
          } ,
        ),

        FloatingActionButton(
          child: const Icon(Icons.reset_tv_outlined),
          onPressed: ()=>{
            fnButton2()
          },


        ),

        FloatingActionButton(
          child: const Icon(Icons.exposure_minus_1_outlined),
          onPressed:(){
            fnButton3(context);
          }
        ),
      ],
    );


  }


}