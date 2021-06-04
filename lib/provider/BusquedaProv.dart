import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Product.dart';

class BusquedaProv with ChangeNotifier {
  SharedPreferences sharedPreferences;
  String _name="";
  set name(String name) {
    this._name=name;
    notifyListeners();
  }

  Future<List<Product>> getproducts(String estado) async {
    sharedPreferences = await SharedPreferences.getInstance();
    int idEmpresa = sharedPreferences.getInt('idEmpresa');
    var url = Uri.parse('https://misventas.azurewebsites.net/api/productList?tipoListado=$estado&nombre=$_name&idEmpresa=$idEmpresa');
    var response = await get(url);
    List<Product> products = [];
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        products.add(Product(item["idProducto"],item["urlImagen"],item["nombre"],item["stock"],1,item["precioVenta"].toDouble(),item["precioVenta"].toDouble(),item["precioCosto"].toDouble(),item["estado"]));
      }
      _name="";
      return products;
    } else {
      throw Exception("Falló la conexión");
    }

  }


}