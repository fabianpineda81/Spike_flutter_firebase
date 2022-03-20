import 'package:sqflite/sqflite.dart';

class Animal {
  int id ;
  String nombre;
  String especie;

  Animal({required this.id,required this.nombre,required this.especie});

  get database => null;

  Map<String, dynamic> toMap(){
    return {'id':id,'nombre':nombre, 'especie':especie};
  }




}