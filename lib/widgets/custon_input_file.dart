
import 'package:flutter/material.dart';


class CustomInputFile extends StatelessWidget {
  final bool    autofocus;
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? counterText;
  final Function actualizarEstado;

  const CustomInputFile({Key? key,required this.autofocus,this.initialValue,this.hintText,this.labelText,this.helperText,this.counterText,required this.actualizarEstado}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   TextFormField(
      autofocus: autofocus,
      initialValue: initialValue,
      textCapitalization: TextCapitalization.words,
      onChanged: (value){
        actualizarEstado(value);
      },
      validator: (value){
        if(value == null ) return "este campo es requerido";
        return  value.length<3? 'el minimo son 3 letras':null ;



      }
      ,
      autovalidateMode: AutovalidateMode.onUserInteraction
      ,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        counterText: counterText,

        //suffixIcon: Icon(Icons.list),
        /* border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10)
                    )
                  )*/
      ),
    );
  }
}

