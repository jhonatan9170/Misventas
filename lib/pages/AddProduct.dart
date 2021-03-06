import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mis_ventas/productImage.dart';
import 'package:mis_ventas/provider/AddProducProv.dart';
import 'package:mis_ventas/provider/BusquedaProv.dart';
import 'package:provider/provider.dart';
class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    final busqueda = Provider.of<BusquedaProv>(context);
    final product = Provider.of<AddProductProv>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Agregar Producto"),),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(

          children: [
            productImage(),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                  labelText: "Nombre del Producto",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  //fillColor: Colors.green
                ),
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onChanged: (input){
                  product.nombre=input;
                },
              ),

            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: new InputDecoration(
                  labelText: "Marca",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  //fillColor: Colors.green
                ),
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onChanged: (input){
                  product.marca=input;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: new InputDecoration(
                  labelText: "Modelo",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  //fillColor: Colors.green
                ),
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onChanged: (input){
                  product.modelo=input;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                maxLines: 2,
                decoration: new InputDecoration(
                  labelText: "Descripcion",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  //fillColor: Colors.green
                ),
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onChanged: (input){
                  product.descripcion=input;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: new InputDecoration(
                  labelText: "Barcode",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.number,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onChanged: (input){
                  if (input==""){
                    product.barCode=0;
                  }else{
                    product.barCode=int.parse(input);}
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.42,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: new InputDecoration(
                      labelText: "Stock",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      //fillColor: Colors.green
                    ),
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (input){
                      if (input==""){
                        product.Stock=0;
                      }else{
                      product.Stock=int.parse(input);}
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.42,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: new InputDecoration(
                      labelText: "Stock Minimo",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.number,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                    onChanged: (input){
                      if (input==""){
                        product.StockMinimo=0;
                      }else{
                        product.StockMinimo=int.parse(input);}
                    },
                  ),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.42,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: new InputDecoration(
                      labelText: "Precio Costo",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      //fillColor: Colors.green
                    ),
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (input){
                      if (input==""){
                        product.precioCosto=0.0;
                      }else{
                        product.precioCosto=double.parse(input);}
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.42,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: new InputDecoration(
                      labelText: "Precio Venta",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (input){
                      if (input==""){
                        product.precioVenta=0.0;
                      }else{
                        product.precioVenta=double.parse(input);}
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),

              ],
            ),

            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              onPressed: () {
                product.sendData().then((value) {
                  print("sended");

                  Fluttertoast.showToast(
                      msg: "Producto a??adido",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );

                  });
                busqueda.name="";
                Navigator.of(context).pop();


              },
              child: Container(padding:EdgeInsets.symmetric(vertical: 12.0,horizontal:40.0 ),child: Text('AGREGAR',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),)),
            ),
          ],
        ),
      ),
    );

  }

}
