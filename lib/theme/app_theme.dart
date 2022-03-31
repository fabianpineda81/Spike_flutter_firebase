

import 'package:flutter/material.dart';

class AppTheme{
  static const Color primary=Colors.green;
  static final ThemeData lightTheme=ThemeData.light().copyWith(
    // color primario
      primaryColor:primary,
      appBarTheme:  const AppBarTheme(
          color: primary,
          elevation: 0
      ),
    textButtonTheme: TextButtonThemeData(
     style:TextButton.styleFrom(primary: primary)
    ),
     buttonTheme:const ButtonThemeData(
     buttonColor: primary
     ),
     floatingActionButtonTheme: const FloatingActionButtonThemeData(
       backgroundColor: primary
     ),
     inputDecorationTheme:  const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary),

       enabledBorder: OutlineInputBorder(
         borderSide: BorderSide(color: primary),
         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))

       ),
         focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(color: primary),
             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))

         ),
         border: OutlineInputBorder(

             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))

         )

  )
  );

  static final ThemeData darkTheme=ThemeData.dark().copyWith(
    // color primario
      primaryColor:primary,
      appBarTheme: const AppBarTheme(
          color: primary,
          elevation: 0
      ),
    scaffoldBackgroundColor: Colors.black

  );



}