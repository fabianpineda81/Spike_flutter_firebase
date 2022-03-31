import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spike_firebase/camara.dart';
import 'package:spike_firebase/herpers/helper_file.dart';
import 'package:spike_firebase/models/dbProvider.dart';
import 'package:spike_firebase/router/app_routes.dart';
import 'package:spike_firebase/screens/folders.dart';
import 'package:spike_firebase/sql_lite.dart';
import 'package:spike_firebase/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HelPerFile.crearDirectorioFinal();
  runApp(const MyApp());
  DBProvider.db;


}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:AppTheme.lightTheme ,
      routes:AppRoutes.getAppRoutes(),
      home:const Folders() ,
    );
  }
}

