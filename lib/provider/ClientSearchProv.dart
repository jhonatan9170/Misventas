import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Models/Cliente.dart';

class ClientSearchProv with ChangeNotifier {
  String _name="";
  set name(String name) {
    this._name=name;
    notifyListeners();
  }
  Future<List<Cliente>> getClients(String estado) async {

    var url = Uri.parse('https://misventas.azurewebsites.net/api/personList?tipoListado=cliente&nombre=$_name');
    var response = await get(url);

    List<Cliente> clients = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        if(estado==item["estado"]){
        if(item["tipoPersona"]=='N'){
          clients.add(Cliente(item["idPersona"],item["nombreCompleto"],item["apePaterno"],item["apeMaterno"],item["nombres"],'N','','',item["telFIjo"],item["celular"],item["dni"],'',item["estado"]));
        }else{
          clients.add(Cliente(item["idPersona"],item["nombreComercial"],'','','','J',item["razonSocial"],item["nombreComercial"],item["telFIjo"],item["celular"],'',item["ruc"],item["estado"]));
        }
        }
        if (estado!='A'&&estado!='I'){
          if(item["tipoPersona"]=='N'){
            clients.add(Cliente(item["idPersona"],item["nombreCompleto"],item["apePaterno"],item["apeMaterno"],item["nombres"],'N','','',item["telFIjo"],item["celular"],item["dni"],'',item["estado"]));
          }else{
            clients.add(Cliente(item["idPersona"],item["nombreComercial"],'','','','J',item["razonSocial"],item["nombreComercial"],item["telFIjo"],item["celular"],'',item["ruc"],item["estado"]));
          }
        }



      }
      return clients;
    } else {
      throw Exception("Falló la conexión");
    }
  }

}