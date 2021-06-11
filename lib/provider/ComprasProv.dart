import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mis_ventas/Models/Persona.dart';
import 'package:mis_ventas/Models/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Comprasprov with ChangeNotifier{
  Persona _proveedor = Persona(64,"Varios","","","","","","","","","","");
  String tipoDocumento = "D.Interno";
  String numeroDocumento = "";
  bool _buttonValidator = true;
  void setbuttonvalidator(bool buttonValidator) {
    this._buttonValidator=buttonValidator;
    notifyListeners();
  }
  bool getbuttonvalidator() => _buttonValidator;
  List<Product> _productList=[];
  Persona getProveedor(){
    return _proveedor;
  }
  List <Product> getProducts(){
    return _productList;
  }
  set proveedor(Persona proveedor) {
    this._proveedor=proveedor;
    notifyListeners();
  }

  void add(Product product) {
    _productList.add(product);
    notifyListeners();
    print(_productList.length);
  }

  void remove(Product product){
    _productList.removeWhere((element) => element.id==product.id);
    notifyListeners();
  }

  void updateCantidad(Product product,int cantidad)
  {
    _productList[_productList.indexOf(product)].cantidad=cantidad;
    notifyListeners();

  }

  void addCantidad(Product product)
  {
    _productList[_productList.indexOf(product)].cantidad++;
    notifyListeners();

  }
  void reduceCantidad(Product product)
  {
    _productList[_productList.indexOf(product)].cantidad--;
    notifyListeners();

  }

  int getCantidad(Product product){
    return  _productList[_productList.indexOf(product)].cantidad;
  }

  double getTotal(){
    var total=0.0;
    for(var prod in _productList){
      total = total+prod.precioCosto*prod.cantidad;
    }
    return total;
  }
  bool isAdded(Product product){
    var isRepeat=false;
    for( var i = 0 ; i < _productList.length; i++ ) {
      if(_productList[i].id==product.id){
        isRepeat=true;
      }
    }
    return isRepeat;

  }
  void setEmpty(){
    _proveedor = Persona(64,"Varios","","","","","","","","","","");
    _productList=[];
  }

  Future<bool> sendData(List products) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int idEmpresa = sharedPreferences.getInt('idEmpresa');
    String usuario =sharedPreferences.getString("usuario");
    print("entra body");
    var body = {
      'documentoRef' : tipoDocumento + " " +numeroDocumento,
      'idProveedor' : _proveedor.id,
      'montoTotal' : getTotal(),
      'usuario' : usuario,
      'jsonCompras':jsonEncode(products),
      'idEmpresa':idEmpresa
    };
    print(body);
     Map<String, String> headers = {"Content-type": "application/json"};

    var url = Uri.parse('https://misventas.azurewebsites.net/api/compra');
    print("antes");
    print(jsonEncode(body));
    var response = await http.post(url,headers: headers , body: jsonEncode(body));
    print("despues");

    print(response.statusCode);
    if(response.statusCode==200){
      setEmpty();
      Fluttertoast.showToast(
          msg: "Compra valida",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return true ;
    }else {
      Fluttertoast.showToast(
          msg: "error en la Compra",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return false;
    }
  }

}