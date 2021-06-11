import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mis_ventas/Models/VentaModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComprasListProv with ChangeNotifier {
  String _name="";
  set name(String name) {
    this._name=name;
    notifyListeners();
  }
  Future<List<VentaModel>> getCompras() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int idEmpresa = sharedPreferences.getInt('idEmpresa');
    var url = Uri.parse('https://misventas.azurewebsites.net/api/compras?idEmpresa=$idEmpresa$_name');
    var response = await get(url);

    List<VentaModel> compras = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        if(item["tipoPersona"]=='N'){
          compras.add(VentaModel(item["idCompra"],item["nombreCompleto"],0.0,0.0,item["montoTotal"].toDouble(),item["date"],item["docReferencia"],""));
        }else
          compras.add(VentaModel(item["idCompra"],item["nombreComercial"],0.0,0.0,item["montoTotal"].toDouble(),item["date"],item["docReferencia"],""));
      }
      compras.sort((a, b) => b.id.compareTo(a.id));
      return compras;
    } else {
      throw Exception("Falló la conexión");
    }
  }

}