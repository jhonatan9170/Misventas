import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mis_ventas/Models/VentaModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VentasListProv with ChangeNotifier {
  String _name="";
  set name(String name) {
    this._name=name;
    notifyListeners();
  }
  Future<List<VentaModel>> getVentas() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int idEmpresa = sharedPreferences.getInt('idEmpresa');
    var url = Uri.parse('https://misventas.azurewebsites.net/api/ventas?idEmpresa=$idEmpresa$_name');
    var response = await get(url);

    List<VentaModel> ventas = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        if(item["tipoPersona"]=='N'){
          ventas.add(VentaModel(item["idVenta"],item["nombreCompleto"],item["subtotal"].toDouble(),item["descuentos"].toDouble(),item["montoTotal"].toDouble(),item["date"]));
        }else
        ventas.add(VentaModel(item["idVenta"],item["nombreComercial"],item["subtotal"].toDouble(),item["descuentos"].toDouble(),item["montoTotal"].toDouble(),item["date"]));
      }
      ventas.sort((a, b) => b.id.compareTo(a.id));
      return ventas;
    } else {
      throw Exception("Falló la conexión");
    }
  }

}