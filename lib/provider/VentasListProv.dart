import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mis_ventas/Models/VentaModel.dart';

class VentasListProv with ChangeNotifier {
  String _name="";
  set name(String name) {
    this._name=name;
    notifyListeners();
  }
  Future<List<VentaModel>> getVentas() async {

    var url = Uri.parse('https://misventas.azurewebsites.net/api/ventas$_name');
    var response = await get(url);

    List<VentaModel> ventas = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        ventas.add(VentaModel(item["idVenta"],item["nombreCompleto"],item["subtotal"].toDouble(),item["descuentos"].toDouble(),item["montoTotal"].toDouble(),item["fechaCreacion"]));
      }
      return ventas;
    } else {
      throw Exception("Falló la conexión");
    }
  }

}