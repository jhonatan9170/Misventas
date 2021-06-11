import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mis_ventas/provider/DetalleVentaProv.dart';
import 'package:mis_ventas/provider/VentasListProv.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class VentasComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ventasList = Provider.of<VentasListProv>(context);
    final products = Provider.of<DetalleVentaProv>(context);

    return FutureBuilder(
      future: ventasList.getVentas(),
      builder: (context,snapshot){
        if (snapshot.hasData) {
          List data = snapshot.data;
          return ListView(children: data.map((venta) =>
              Card( margin: EdgeInsets.all(5.0),
                child: ListTile(
                  onTap: (){
                    products.idVenta=venta.id;
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
                                padding: EdgeInsets.symmetric(vertical: 8.0), child: Row(children: [Icon(Icons.file_copy_rounded,color: Colors.purple,),Text("  "+venta.documento+ " : " +venta.numDocumento)],)
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,  children: [Text("Cliente",),Text(venta.nombreUsuario)])
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
                                                     Text("Prec unit  S/"+product.preciounit.toString()),
                                                     Text( product.cantidad.toString()+" x  S/"+product.preciofinal.toString()),
                                                   ],),
                                                   trailing: Text("S/"+(product.cantidad*product.preciofinal).toString()),
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
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,  children: [
                                    Stack(children: [Container( alignment: Alignment.centerLeft,child: Text("Subtotal",)),Container( alignment: Alignment.centerRight,child: Text("S/"+venta.subTotal.toString(),)),]),
                                    Stack(children: [Container( alignment: Alignment.centerLeft,child: Text("Descuento",)),Container( alignment: Alignment.centerRight,child: Text("S/"+venta.descuento.toString(),)),]),
                                  ])
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                child:Stack(children: [Container( alignment: Alignment.centerLeft,child: Text("Total",)),Container( alignment: Alignment.centerRight,child: Text("S/"+venta.monto.toString(),)),]),
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
                                          ELiminar(venta.id).then((value)  {
                                            int count = 0;
                                            Navigator.of(context).popUntil((_) => count++ >= 2);
                                            ventasList.name="";
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
                  minVerticalPadding: 10.0,
                  tileColor: Color(0xfff6f5f5),
                  title: Text(venta.nombreUsuario),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(venta.fecha),Text(venta.documento+ " : " +venta.numDocumento)]),
                  leading: CircleAvatar(child: Text(venta.nombreUsuario.substring(0,1))),
                  trailing: Text("S/"+venta.monto.toString(),style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),),
              )
          ).toList());
        }else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Error");}
        return Center(child: CircularProgressIndicator(),);
      }
      );


  }
  Future  ELiminar(int id) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int idEmpresa = sharedPreferences.getInt('idEmpresa');
    String usuario =sharedPreferences.getString("usuario");
    var body = {
      'idVenta' : id,
      'estado' :'I',
      'usuario' :usuario,
      'idEmpresa':idEmpresa
    };
    print(body);
    Map<String, String> headers = {"Content-type": "application/json"};
    var url = Uri.parse('https://misventas.azurewebsites.net/api/ventas');
    var response = await http.delete(url,headers: headers , body: jsonEncode(body));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');



  }
}

