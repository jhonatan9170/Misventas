import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Cliente.dart';

class ClientSearchProv with ChangeNotifier {
  SharedPreferences sharedPreferences;
  String _name="";
  set name(String name) {
    this._name=name;
    notifyListeners();
  }
  Future<List<Persona>> getClients(String estado) async {
    sharedPreferences = await SharedPreferences.getInstance();
    int idEmpresa = sharedPreferences.getInt('idEmpresa');
    var url = Uri.parse('https://misventas.azurewebsites.net/api/personList?tipoListado=cliente&nombre=$_name&idEmpresa=$idEmpresa');
    var response = await get(url);

    List<Persona> clients = [];
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        if(estado==item["estado"]){
        if(item["tipoPersona"]=='N'){
          clients.add(Persona(item["idPersona"],item["nombreCompleto"],item["apellidos"],item["nombres"],'N','','',item["telFIjo"],item["celular"],item["dni"],'',item["estado"]));
        }else{
          clients.add(Persona(item["idPersona"],item["nombreComercial"],'','','J',item["razonSocial"],item["nombreComercial"],item["telFIjo"],item["celular"],'',item["ruc"],item["estado"]));
        }
        }
        if (estado!='A'&&estado!='I'){
          if(item["tipoPersona"]=='N'){
            clients.add(Persona(item["idPersona"],item["nombreCompleto"],item["apellidos"],item["nombres"],'N','','',item["telFIjo"],item["celular"],item["dni"],'',item["estado"]));
          }else{
            clients.add(Persona(item["idPersona"],item["nombreComercial"],'','','J',item["razonSocial"],item["nombreComercial"],item["telFIjo"],item["celular"],'',item["ruc"],item["estado"]));
          }
        }
      }
      _name="";
      return clients;
    } else {
      throw Exception("Falló la conexión");
    }
  }

}