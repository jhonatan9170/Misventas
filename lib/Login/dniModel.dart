import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
class dniModel{
  String dni = "";
  String nombre = "";
  String apellidos = "";
  String nombreCompleto= "";
  Future<void> set(String dni)async{

    var url = Uri.parse('https://dni.optimizeperu.com/api/persons/$dni');
    var response = await get(url);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData);
      if(jsonData["name"]==null){
        this.dni="";
        this.nombre = "";
        this.apellidos = "";
        Fluttertoast.showToast(
            msg: "DNI no valido",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        this.nombreCompleto="";
      }else{
        this.dni =dni;
        this.nombre = jsonData["name"];
        this.apellidos = jsonData["first_name"]+" "+jsonData["last_name"];
        this.nombreCompleto =  apellidos+" ,"+nombre;
      }

    } else {
      this.dni="";
      this.nombre = "";
      this.apellidos = "";
      Fluttertoast.showToast(
          msg: "DNI no valido",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      this.nombreCompleto="";
    }


  }
}