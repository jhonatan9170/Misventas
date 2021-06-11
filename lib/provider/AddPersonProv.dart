import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AddPersonaProv with ChangeNotifier {
  SharedPreferences sharedPreferences;
  String apellidos = "";
  String nombres = "";
  String modelo = "";
  String tipoPersona = "N";
  String razonSocial = "";
  String nombreComercial = "";
  String telFijo = "";
  String celular = "";
  String ruc = "";
  String dni = "";


  Future sendData(String condicion) async {
    sharedPreferences = await SharedPreferences.getInstance();
    int idEmpresa = sharedPreferences.getInt('idEmpresa');
    String usuario =sharedPreferences.getString("usuario");

      var url = Uri.parse('https://misventas.azurewebsites.net/api/personList');
      var body = {
        "condicion" : condicion,
        "apellidos" : apellidos.toUpperCase(),
        "nombres" :nombres.toUpperCase(),
        "nombreCompleto": "$apellidos ,$nombres".toUpperCase(),
        "tipoPersona" :tipoPersona,
        "razonSocial":	razonSocial,
        "nombreComercial": nombreComercial,
        "telFijo" :telFijo,
        "celular" :celular,
        "dni" : dni,
        "ruc" : ruc,
        "usuario" : usuario,
        "idEmpresa" :idEmpresa

      };
      print(body);
      Map<String, String> headers = {"Content-type": "application/json"};
      var response = await http.post(
          url, headers: headers, body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
  }

  void esNatural (){
    tipoPersona="N";
    nombreComercial="";
    razonSocial="";
    ruc="";
  }
  void esJuridica(){
    apellidos = "";
    nombres="";
    tipoPersona="J";
    dni="";

  }
  void clear(){
    apellidos = "";
    nombres = "";
    modelo = "";
    tipoPersona = "N";
    razonSocial = "";
    nombreComercial = "";
    telFijo = "";
    celular = "";
    ruc = "";
    dni = "";
  }




}