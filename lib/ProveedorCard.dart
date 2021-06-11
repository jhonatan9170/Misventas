import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mis_ventas/provider/ProveedorSearchProv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ProveedorCard extends StatelessWidget {
  String _estado;
  ProveedorCard(this._estado);
  @override
  Widget build(BuildContext context) {
    final proveedorList = Provider.of<ProveedorSearchProv>(context);
    return  FutureBuilder(
        future: proveedorList.getProveedores(_estado),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data;
            return ListView(children: data.map((proveedor) =>
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 16.0),
                  child: ListTile(
                      onTap: (){
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      proveedor.tipoPersona=='N' ?
                                      Column(
                                        children: [
                                          Row(children: [Text("Apellidos ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(proveedor.apellidos.toString(),style: TextStyle(fontSize: 18.0,),),]),
                                          Row(children: [Text("Nombres ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(proveedor.nombres,style: TextStyle(fontSize: 18.0,),),],),
                                          Row(children: [Text("DNI ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(proveedor.dni.toString(),style: TextStyle(fontSize: 18.0,),),],),
                                        ],
                                      ):
                                      Column(
                                        children: [
                                          Row(children: [Text("Razon Social ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(proveedor.razonSocial,style: TextStyle(fontSize: 18.0,),),],),
                                          Row(children: [Text("Nombre Comercial ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(proveedor.nombreComercial,style: TextStyle(fontSize: 18.0,),),],),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(children: [Text("Telefono fijo ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(proveedor.telfijo.toString(),style: TextStyle(fontSize: 18.0,),),],),
                                          Row(children: [Text("Celular ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(proveedor.celular.toString(),style: TextStyle(fontSize: 18.0,),),],
                                          ),
                                        ],
                                      ),
                                      proveedor.estado=='A'?
                                      Column(
                                        children: [
                                          Text("ACTIVO ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                                          ElevatedButton( child: Text("ELIMINAR ",style: TextStyle(fontSize: 18.0,),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                            onPressed: (){
                                              showDialog(context: context, builder: (BuildContext context){
                                                return AlertDialog(
                                                  title: Text('Alerta'),
                                                  content: SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text('¿Esta seguro de eliminar a ' +proveedor.nombreCompleto+" ?" ),
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
                                                        Eliminar(proveedor.id,'I').then((value)  {


                                                          proveedorList.name="";
                                                          Fluttertoast.showToast(
                                                              msg: "Proveedor eliminado",
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
                                            },


                                          )
                                        ],
                                      ):
                                      Column(
                                        children: [
                                          Text("INACTIVO ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                                          ElevatedButton( child: Text("ACTIVAR ",style: TextStyle(fontSize: 18.0,),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                                            onPressed: (){
                                              showDialog(context: context, builder: (BuildContext context){
                                                return AlertDialog(
                                                  title: Text('Alerta'),
                                                  content: SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text('¿Esta seguro de reponer a ' +proveedor.nombreCompleto+" ?" ),
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
                                                      child: Text('ACTIVAR'),
                                                      onPressed: () {
                                                        Eliminar(proveedor.id,'A').then((value)  {
                                                          int count = 0;
                                                          Navigator.of(context).popUntil((_) => count++ >= 2);
                                                          proveedorList.name="";
                                                          Fluttertoast.showToast(
                                                              msg: "Proveedor repuesto",
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
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });


                      },
                      minVerticalPadding: 10.0,
                      tileColor: Color(0xfff6f5f5),
                      title: Text(proveedor.nombreCompleto), subtitle:  (proveedor.estado=='A' ? Text("Activo",style: TextStyle(color: Colors.green),):Text("Inactivo",style: TextStyle(color: Colors.red))) ,
                      leading: CircleAvatar(
                        child: Text(proveedor.nombreCompleto.substring(0,1)),
                      )
                  ),
                )

            ).toList());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Error");}
          return Center(child: CircularProgressIndicator(),);
        });
  }


  Future  Eliminar(int id,String state) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int idEmpresa = sharedPreferences.getInt('idEmpresa');
    String usuario =sharedPreferences.getString("usuario");
    var body = {
      'idPersona' : id,
      'estado' : state,
      'usuario': usuario,
      'idEmpresa' : idEmpresa
    };
    print(body);
    Map<String, String> headers = {"Content-type": "application/json"};
    var url = Uri.parse('https://misventas.azurewebsites.net/api/personList');
    var response = await http.delete(url,headers: headers , body: jsonEncode(body));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');



  }
}
