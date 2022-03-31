

import 'package:flutter/material.dart';
import 'package:spike_firebase/screens/folder.dart';
import 'package:spike_firebase/screens/formulario_folder.dart';
import 'package:spike_firebase/screens/formulario_imagen.dart';

import '../models/menu_option.dart';
import '../screens/folders.dart';
import '../screens/reestore.dart';


class AppRoutes{
  static const initialRouter='home';
  static final menuOptions=<MenuOption>[
    //TODO: borrar home;
    MenuOption(route: "formsImage", name: "crear imagen", screen: const FormImage(), icon: Icons.add),
    MenuOption(route: "forms",      name: "crear folder", screen: const FormFolder(), icon: Icons.add),
    MenuOption(route: "folder",     name: "mostrar folder", screen:  Folder(), icon: Icons.add),
    MenuOption(route: "folders",    name: "mostrar folders", screen:  const Folders(), icon: Icons.add),
    MenuOption(route: "reestore", name: "reestore folders", screen:  Resstore(), icon: Icons.add),



  ];
  static Map<String, Widget Function(BuildContext)> getAppRoutes(){
    Map<String, Widget Function(BuildContext)> appRoutes={};
    for(final option in menuOptions){
      appRoutes.addAll({option.route:(context) => option.screen});
    }

    return appRoutes;
  }


  /*static Map<String, Widget Function(BuildContext)> routes= {
    'home'      :(context) => const HomeScreen(),
    'listview1' :(context) => const ListView1Screen(),
    'listview2' :(context) => const ListView2Screen(),
    'alert'     :(context) => const AlertScreen(),
    'card'      :(context) => const CardScreen()
  };*/
  static   Route<dynamic> onGenerateRoute  (RouteSettings settings){
  return MaterialPageRoute(builder: (context) => const FormFolder());

  }
}