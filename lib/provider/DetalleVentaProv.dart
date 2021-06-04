import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mis_ventas/Models/Product.dart';


class DetalleVentaProv with ChangeNotifier {
  int _idVenta;
  set idVenta(int id) {
    this._idVenta=id;
    notifyListeners();
  }
  Future<List<Product>> getproducts() async {
    var url = Uri.parse('https://misventas.azurewebsites.net/api/detallesVenta?idVenta=$_idVenta');
    var response = await get(url);

    List<Product> products = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        products.add(Product(item["idProducto"],'',item["nombre"],1,item["cantidad"],item["precioUnitario"].toDouble(),item["precioFinal"].toDouble(),0.0,'A'));
      }
      return products;
    } else {
      throw Exception("Falló la conexión");
    }
  }

}