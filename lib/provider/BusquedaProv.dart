import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Models/Product.dart';

class BusquedaProv with ChangeNotifier {
  String _name="";
  set name(String name) {
    this._name=name;
    notifyListeners();
  }
  Future<List<Product>> getproducts() async {

    var url = Uri.parse('https://misventas.azurewebsites.net/api/productList?tipoListado=A&nombre=$_name');
    var response = await get(url);

    List<Product> products = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        products.add(Product(item["idProducto"],'https://www.llevateloya.pe/1228-home_default/leche-evaporada-gloria-super-light-lata-400-gr.jpg',item["nombre"],item["stock"],1,item["precioVenta"].toDouble(),item["precioVenta"].toDouble(),0.0));
      }
      return products;
    } else {
      throw Exception("Falló la conexión");
    }
  }

}