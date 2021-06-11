import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mis_ventas/Models/Product.dart';


class DetalleComprasProv with ChangeNotifier {
  int _idCompra;
  set idCompra(int id) {
    this._idCompra=id;
    notifyListeners();
  }
  Future<List<Product>> getproducts() async {
    var url = Uri.parse('https://misventas.azurewebsites.net/api/detallesCompra?idCompra=$_idCompra');
    var response = await get(url);

    List<Product> products = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        products.add(Product(item["idProducto"],'',item["nombre"],1,item["cantidad"],0.0,0.0,item["precio"].toDouble(),'A'));
      }
      return products;
    } else {
      throw Exception("Falló la conexión");
    }
  }

}