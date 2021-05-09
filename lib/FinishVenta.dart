import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mis_ventas/provider/VentasListProv.dart';
import 'package:provider/provider.dart';

import 'provider/Ventasprov.dart';

class FinishVenta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    final ventas = Provider.of<Ventasprov>(context);
    final ventasList = Provider.of<VentasListProv>(context);
    Future sendData() async {
      var products = [];
      for (var prop in ventas.getProducts()) {
        var product = {"idProducto":prop.id,"precioUnitario":prop.preciounit,"precioFinal":prop.preciofinal,"descuento":prop.getDescuento(),"cantidad":prop.cantidad,"total":prop.preciofinal*prop.cantidad};
        products.add(product);
      }
      var body = {
        'idTipoDocumento' : 4,
        'idCliente' : ventas.getCLiente().id,
        'subTotal' : ventas.getSubtotal(),
        'descuentos' : ventas.getDescuento(),
        'montoTotal' : ventas.getTotal(),
        'pago':ventas.getPago(),
        'vuelto':ventas.getVuelto(),
        'usuario' : 'JCHAVEZ',
        'jsonCompras':jsonEncode(products)
      };
      print(body);
      Map<String, String> headers = {"Content-type": "application/json"};
      var url = Uri.parse('https://misventas.azurewebsites.net/api/ventas');
      var response = await http.post(url,headers: headers , body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }



    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.0),
      height: 180.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //IconButton(icon: Icon(Icons.), onPressed: (){}),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Total   ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0)),Text("S/"+ventas.getTotal().toString(),style: TextStyle(fontSize: 18.0))],),
          Container(
            margin: EdgeInsets.all(3.0),
            width: MediaQuery.of(context).size.width*0.8,
            height: 40.0,
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: (input){
                if (input == ""){
                  ventas.pago=0.0;
                }else {
                  ventas.pago=double.parse(input);
                }

              },
              onSubmitted: (input){
                if (input == ""){
                  ventas.pago=0.0;
                }else {
                  ventas.pago=double.parse(input);
                }
              },
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                labelText: "Paga con ",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center, children: [Text("Vuelto ",style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 18.0),),
            Text("S/"+ventas.getVuelto(),style: TextStyle(fontSize: 18.0))],
          ),
          ElevatedButton(child: Text("PAGAR"),
            style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50.0))),
          onPressed: (){
            sendData().then((value)
            {
              ventas.setEmpty();
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 2);
              ventasList.name="";
              Fluttertoast.showToast(
                  msg: "Venta Hecha",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            ).catchError((error){
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            });

          },
          ),
        ]


      ),
    );
  }




}
