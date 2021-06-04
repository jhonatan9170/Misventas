import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mis_ventas/Models/Product.dart';
import 'package:mis_ventas/pages/AddProduct.dart';
import 'package:mis_ventas/provider/BusquedaProv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListProduct extends StatefulWidget {

  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  String estado = 'A';
  String _chosenValue='ACTIVOS';
  @override
  Widget build(BuildContext context) {
    final busqueda = Provider.of<BusquedaProv>(context);
    Widget ListComponent(Product prod){

      return Card(
        child: ListTile(
          minVerticalPadding: 10.0,
          title: Text(prod.productName),
          subtitle: Column(
            children: [
              Text("Punit: " +prod.preciounit.toString()),
              Text("Stock: "+prod.stock.toString()),
              prod.estado=='A' ? Text("Activo",style: TextStyle(color: Colors.green),):Text("Inactivo",style: TextStyle(color: Colors.red))
              ,
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          leading: GestureDetector(child: Image.network(prod.url),
            onTap: (){
              showDialog(
                  useSafeArea: false,
                  context: context,
                  builder: (_)=> GestureDetector(
                      onVerticalDragUpdate: (dragUpdateDetails) {
                        Navigator.of(context).pop();
                      },
                      child: Image.network(prod.url)
                  )
              );
            },
          ),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Row(children: [Text("Nombre del Producto ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(prod.productName,style: TextStyle(fontSize: 18.0,),),]),
                            Row(children: [Text("Marca  ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text("Cualquiera",style: TextStyle(fontSize: 18.0,),),],),
                            Row(children: [Text("Modelo ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text("Cualquiera",style: TextStyle(fontSize: 18.0,),),],),
                            Row(children: [Text("Stock ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text(prod.stock.toString(),style: TextStyle(fontSize: 18.0,),),],),
                            Row(children: [Text("Precio Unitario ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text("s/ " +prod.preciounit.toString(),style: TextStyle(fontSize: 18.0,),),],),
                            Row(children: [Text("Costo ",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),), Text("s/ " +prod.precioCosto.toString(),style: TextStyle(fontSize: 18.0,),),],),
                          ],
                        ),

                        prod.estado=='A'?
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
                                          Text('¿Esta seguro de eliminar  ' +prod.productName+" ?" ),
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
                                          Eliminar(prod.id,'I').then((value)  {
                                            int count = 0;
                                            Navigator.of(context).popUntil((_) => count++ >= 2);
                                            busqueda.name="";
                                            Fluttertoast.showToast(
                                                msg: "Producto eliminado",
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
                                          Text('¿Esta seguro de reponer a ' +prod.productName+" ?" ),
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
                                          Eliminar(prod.id,'A').then((value)  {
                                            int count = 0;
                                            Navigator.of(context).popUntil((_) => count++ >= 2);
                                            busqueda.name="";
                                            Fluttertoast.showToast(
                                                msg: "Producto repuesto",
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





        ),
      );
    }


    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8.0),
                  width: MediaQuery.of(context).size.width*0.5,
                  child: TextField(
                    onChanged: (input)=>busqueda.name=input,
                    textAlign: TextAlign.center,
                    decoration: new InputDecoration(
                      labelText: "Busqueda",
                      fillColor: Colors.white,
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(5),  // Added this
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ), //fillColor: Colors.green
                    ),
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),


                DropdownButton<String>(
                  focusColor:Colors.white,
                  value: _chosenValue,
                  //elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor:Colors.black,
                  items: <String>[
                    'ACTIVOS',
                    'INACTIVOS',
                    'TODOS'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style:TextStyle(color:Colors.black),),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    setState(() {
                      switch(value) {
                        case 'ACTIVOS':
                          estado='A';
                          break;
                        case 'INACTIVOS':
                          estado='I';
                          break;
                        default :
                          estado='T';
                          break;
                      }
                      _chosenValue = value;
                    });
                  },
                )
              ],
            ),

          ),


          Expanded(
            child: FutureBuilder(
                future: busqueda.getproducts(estado),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data;
                    return ListView(
                        children: data.map((prod) => ListComponent(prod)).toList());
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text("Error");}
                  return Center(child: CircularProgressIndicator(),);
                }
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>AddProduct()));
      },

      ),


    );

  }


  Future  Eliminar(int id,String state) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int idEmpresa = sharedPreferences.getInt('idEmpresa');
    String usuario =sharedPreferences.getString("usuario");
    var body = {
      'idProducto' : id,
      'estado' : state,
      'usuario':usuario,
      "idEmpresa" :idEmpresa
    };
    print(body);
    Map<String, String> headers = {"Content-type": "application/json"};
    var url = Uri.parse('https://misventas.azurewebsites.net/api/productList');
    var response = await http.delete(url,headers: headers , body: jsonEncode(body));

  }
}

