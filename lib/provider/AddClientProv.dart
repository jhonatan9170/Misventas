import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AddClientProv with ChangeNotifier {

  String apePaterno = "";
  String apeMaterno = "";
  String nombres = "";
  String modelo = "";
  String tipoPersona = "N";
  String razonSocial = "";
  String nombreComercial = "";
  String telFijo = "";
  String celular = "";
  String ruc = "";
  int dni = 0;
  String usuario = "JCHAVEZ";


  Future sendData(String condicion) async {
      var url = Uri.parse('https://misventas.azurewebsites.net/api/personList');
      var body = {
        "condicion" : condicion,
        "apePaterno" : apePaterno,
        "apeMaterno" : apeMaterno,
        "nombres" :nombres,
        "nombreCompleto": "$apePaterno $apeMaterno $nombres",
        "tipoPersona" :tipoPersona,
        "razonSocial":	razonSocial,
        "nombreComercial": nombreComercial,
        "telFijo" :telFijo,
        "celular" :celular,
        "dni" : dni,
        "ruc" : ruc,
        "usuario" : usuario

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
    apePaterno="";
    apeMaterno="";
    nombres="";
    tipoPersona="J";
    dni=0;

  }




}