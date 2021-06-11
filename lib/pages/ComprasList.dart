
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mis_ventas/provider/ComprasListProv.dart';
import 'package:mis_ventas/provider/DetalleComprasProv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Compras.dart';

class ComprasList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final comprasList = Provider.of<ComprasListProv>(context);
    final products = Provider.of<DetalleComprasProv>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Compras()),);
        },
      ),
      body: FutureBuilder(
          future: comprasList.getCompras(),
          builder: (context,snapshot){
            if (snapshot.hasData) {
              List data = snapshot.data;
              return ListView(children: data.map((compra) =>
                  Card( margin: EdgeInsets.all(5.0),
                    child: ListTile(
                      minVerticalPadding: 10.0,
                      tileColor: Color(0xfff6f5f5),
                      title: Text(compra.nombreUsuario),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(compra.fecha),Text(compra.documento)]),
                      leading: CircleAvatar(child: Text(compra.nombreUsuario.substring(0,1))),
                      trailing: Text("S/"+compra.monto.toString(),style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                      onTap: (){
                        products.idCompra=compra.id;
                        showModalBottomSheet(shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                            isScrollControlled: true,context: context, builder: (BuildContext bc){
                              return SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Container(
                                          padding: EdgeInsets.symmetric(vertical: 8.0), child: Row(children: [Icon(Icons.file_copy_rounded,color: Colors.purple,),Text("  "+compra.documento)],)
                                      ),
                                      Container(
                                          margin: EdgeInsets.symmetric(vertical: 8.0),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,  children: [Text("Proveedor",),Text(compra.nombreUsuario)])
                                      ),
                                      Container(
                                          margin: EdgeInsets.symmetric(vertical: 8.0),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,  children: [Text("Productos",),
                                            FutureBuilder(
                                                future: products.getproducts(),
                                                builder: (context,snapshot){
                                                  if(snapshot.hasData){
                                                    List productList = snapshot.data;
                                                    return ListView(
                                                      scrollDirection: Axis.vertical,
                                                      shrinkWrap: true,
                                                      children: productList.map((product) =>
                                                          Card(
                                                            child: ListTile(
                                                              title: Text(product.productName.toString()),
                                                              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                Text( product.cantidad.toString()+" x  S/"+product.precioCosto.toString()),
                                                              ],),
                                                              trailing: Text("S/"+(product.cantidad*product.precioCosto).toString()),
                                                            ),
                                                          )
                                                      ).toList(),

                                                    );
                                                  }else if (snapshot.hasError) {
                                                    return Text("error");
                                                  }
                                                  return Center(child: CircularProgressIndicator(),);
                                                }),

                                          ])
                                      ),

                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 8.0),
                                        child:Stack(children: [Container( alignment: Alignment.centerLeft,child: Text("Total",)),Container( alignment: Alignment.centerRight,child: Text("S/"+compra.monto.toString(),)),]),
                                      ),
                                      Center(child: ElevatedButton(child: Text("Eliminar") ,style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                        onPressed: (){
                                          showDialog(context: context, builder: (BuildContext context){
                                            return AlertDialog(
                                              title: Text('Alerta'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text('¿Esta seguro de eliminar la Venta ?'),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('CANCELAR'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('ELIMINAR'),
                                                  onPressed: () {
                                                    int count = 0;
                                                    Navigator.of(context).popUntil((_) => count++ >= 2);
                                                    ELiminar(compra.id).then((value)  {
                                                      comprasList.name="";
                                                      Fluttertoast.showToast(
                                                          msg: "Venta eliminado",
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
                                              ],
                                            );
                                          });
                                        }, ))

                                    ],
                                  ),
                                ),
                              );
                            });
                      },

                    ),
                  )
              ).toList());
            }else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("Error");}
            return Center(child: CircularProgressIndicator(),);
          }
      )

    );
  }
  Future  ELiminar(int id) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int idEmpresa = sharedPreferences.getInt('idEmpresa');
    String usuario =sharedPreferences.getString("usuario");
    var body = {
      'idCompra' : id,
      'estado' :'I',
      'usuario' :usuario,
      'idEmpresa':idEmpresa
    };
    print(body);
    Map<String, String> headers = {"Content-type": "application/json"};
    var url = Uri.parse('https://misventas.azurewebsites.net/api/compra');
    var response = await http.delete(url,headers: headers , body: jsonEncode(body));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');



  }
}
