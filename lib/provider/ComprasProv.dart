import 'package:flutter/material.dart';
import 'package:mis_ventas/Models/Cliente.dart';
import 'package:mis_ventas/Models/Product.dart';


class Comprasprov with ChangeNotifier{
  Persona _proveedor = Persona(64,"Varios","","","","","","","","","","");
  List<Product> _productList=[];
  Persona getCLiente(){
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

}