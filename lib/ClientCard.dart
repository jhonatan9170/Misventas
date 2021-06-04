import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'provider/ClientSearchProv.dart';
import 'provider/Ventasprov.dart';
import 'package:http/http.dart' as http;

class ClientCard extends StatelessWidget {
  bool _isGeneral;
  String _estado;
  ClientCard(this._estado,this._isGeneral);
  @override
  Widget build(BuildContext context) {
    final clientes = Provider.of<ClientSearchProv>(context);
    final venta = Provider.of<Ventasprov>(context);
    return  FutureBuilder(
        future: clientes.getClients(_estado),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data;
            return ListView(children: data.map((client) =>
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 16.0),
                  child: ListTile(
                    onTap: (){
                      if(!_isGeneral){
                        venta.cliente=client;
                        Navigator.pop(context);
                      }else{
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    client.tipoPersona=='N' ?
                                    Column(
                                      children: [
                                        Row(children: [Text("Apellidos ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(client.apellidos.toString(),style: TextStyle(fontSize: 18.0,),),]),
                                        Row(children: [Text("Nombres ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(client.nombres,style: TextStyle(fontSize: 18.0,),),],),
                                        Row(children: [Text("DNI ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(client.dni.toString(),style: TextStyle(fontSize: 18.0,),),],),
                                      ],
                                    ):
                                    Column(
                                      children: [
                                        Row(children: [Text("Razon Social ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(client.razonSocial,style: TextStyle(fontSize: 18.0,),),],),
                                        Row(children: [Text("Nombre Comercial ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(client.nombreComercial,style: TextStyle(fontSize: 18.0,),),],),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(children: [Text("Telefono fijo ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(client.telfijo.toString(),style: TextStyle(fontSize: 18.0,),),],),
                                        Row(children: [Text("Celular ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(client.celular.toString(),style: TextStyle(fontSize: 18.0,),),],
                                        ),
                                      ],
                                    ),
                                    client.estado=='A'?
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
                                                      Text('¿Esta seguro de eliminar a ' +client.nombreCompleto+" ?" ),
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
                                                      Eliminar(client.id,'I').then((value)  {


                                                        clientes.name="";
                                                        Fluttertoast.showToast(
                                                            msg: "Cliente eliminado",
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
                                                      Text('¿Esta seguro de reponer a ' +client.nombreCompleto+" ?" ),
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
                                                      Eliminar(client.id,'A').then((value)  {
                                                        int count = 0;
                                                        Navigator.of(context).popUntil((_) => count++ >= 2);
                                                        clientes.name="";
                                                        Fluttertoast.showToast(
                                                            msg: "Cliente repuesto",
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
                      }

                    },
                    minVerticalPadding: 10.0,
                    tileColor: Color(0xfff6f5f5),
                    title: Text(client.nombreCompleto), subtitle: _isGeneral ? (client.estado=='A' ? Text("Activo",style: TextStyle(color: Colors.green),):Text("Inactivo",style: TextStyle(color: Colors.red))) : Column(),
                    leading: CircleAvatar(
                      child: Text(client.nombreCompleto.substring(0,1)),
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
