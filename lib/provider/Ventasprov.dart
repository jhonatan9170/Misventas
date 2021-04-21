import 'package:flutter/material.dart';
import 'package:mis_ventas/Models/Cliente.dart';
import 'package:mis_ventas/Models/Product.dart';


class Ventasprov with ChangeNotifier{
  Cliente _cliente = Cliente(0,"","");
  List<Product> _productList=[];
  double _pago =0.0;
  Cliente getCLiente(){
    return _cliente;
  }
  List <Product> getProducts(){
    return _productList;
  }
  set cliente(Cliente cliente) {
    this._cliente=cliente;
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
  set pago (double pago){
    this._pago=pago;
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
 double getSubtotal(){
    var total=0.0;
    for(var prod in _productList){
      total = total+prod.preciounit*prod.cantidad;
    }
    return total;
 }
  double getTotal(){
    var total=0.0;
    for(var prod in _productList){
      total = total+prod.preciofinal*prod.cantidad;
    }
    return total;
  }
  double getDescuento(){
    return getSubtotal()-getTotal();
  }

  String getVuelto(){
    if (_pago==0.0) {
      return "";
    }else{
        return (_pago-getTotal()).toString();
    }
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
}