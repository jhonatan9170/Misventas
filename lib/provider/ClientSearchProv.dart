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
  Future<List<Cliente>> getClients() async {

    var url = Uri.parse('https://misventas.azurewebsites.net/api/personList?tipoListado=cliente&nombre=$_name');
    var response = await get(url);

    List<Cliente> clients = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
         String name = item["nombres"];
         String apeMaterno = item["apeMaterno"];
         String apePaterno = item["apePaterno"];
        clients.add(Cliente(item["idPersona"],item["urlImagen"],'$name $apePaterno $apeMaterno'));
      }
      print(clients[1].nombreCompleto);
      return clients;
    } else {
      throw Exception("Falló la conexión");
    }
  }

}