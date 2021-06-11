import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mis_ventas/provider/VentasListProv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/Ventasprov.dart';

class FinishVenta extends StatefulWidget {

  @override
  _FinishVentaState createState() => _FinishVentaState();
}

class _FinishVentaState extends State<FinishVenta> {
  String _chosenValue='D.Interno';
  bool press ;
  @override
  void initState() {
    super.initState();
    press=false;
  }


  @override
  Widget build(BuildContext context) {


    final ventas = Provider.of<Ventasprov>(context);
    final ventasList = Provider.of<VentasListProv>(context);


    Future sendData() async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      int idEmpresa = sharedPreferences.getInt('idEmpresa');
      String usuario =sharedPreferences.getString("usuario");
      var products = [];
      for (var prop in ventas.getProducts()) {
        var product = {"idProducto":prop.id,"precioUnitario":prop.preciounit,"precioFinal":prop.preciofinal,"descuento":prop.getDescuento(),"cantidad":prop.cantidad,"total":prop.preciofinal*prop.cantidad};
        products.add(product);
      }
      var body = {
        'tipoDocumento' : ventas.tipoDocumento,
        'idCliente' : ventas.getCLiente().id,
        'subTotal' : ventas.getSubtotal(),
        'descuentos' : ventas.getDescuento(),
        'montoTotal' : ventas.getTotal(),
        'pago':ventas.getPago(),
        'vuelto':ventas.getVuelto(),
        'usuario' : usuario,
        'jsonCompras':jsonEncode(products),
        'idEmpresa':idEmpresa
      };
      Map<String, String> headers = {"Content-type": "application/json"};
      var url = Uri.parse('https://misventas.azurewebsites.net/api/ventas');
      var response = await http.post(url,headers: headers , body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
  /*    print('Response body: ${response.body}');
      print(body);*/
    }

    return Container(
      padding: MediaQuery.of(context).viewInsets,
      margin: EdgeInsets.all(5.0),
      //height: 200.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
            focusColor:Colors.white,
            value: _chosenValue,
            style: TextStyle(color: Colors.white),
            iconEnabledColor:Colors.black,
            items: <String>[
              'D.Interno',
              'Boleta',
              'Factura'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,style:TextStyle(color:Colors.black),),
              );
            }).toList(),
            onChanged: (String value) {
              setState(() {
                ventas.setTipoDocumento(value);
                _chosenValue = value;
              });
            },
          ),



          Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Total   ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0)),Text("S/"+ventas.getTotal().toString(),style: TextStyle(fontSize: 18.0))],),
          Container(
            margin: EdgeInsets.all(3.0),
            width: MediaQuery.of(context).size.width*0.8,
            //height: 40.0,
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
                prefix: Text("s/"),
                labelText: "Paga con ",
                isDense: true,                      // Added this
                contentPadding: EdgeInsets.all(15),
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
          onPressed: press ? null : (){
            if(ventas.getPago()>=ventas.getTotal()&&ventas.getProducts().length>0){
              setState(() {
                press=true;
              });
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


            }else{
              Fluttertoast.showToast(
                  msg: "Error en la Compra",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

            }

          },
          ),
        ]


      ),
    );
  }
}
