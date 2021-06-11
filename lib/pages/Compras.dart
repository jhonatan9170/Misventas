
import 'package:flutter/material.dart';
import 'package:mis_ventas/Components/ProveedorSearch.dart';
import 'package:mis_ventas/Models/Persona.dart';
import 'package:mis_ventas/pages/productSearch.dart';
import 'package:mis_ventas/provider/ComprasListProv.dart';
import 'package:mis_ventas/provider/ComprasProv.dart';
import 'package:provider/provider.dart';

import '../ProductComponent.dart';
import 'ClientsSearch.dart';
import 'package:http/http.dart' as http;
class Compras extends StatefulWidget {
  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<Compras> {
  bool press = true ;
  @override
  Widget build(BuildContext context) {
    final compras = Provider.of<Comprasprov>(context);
    final comprasList = Provider.of<ComprasListProv>(context);
    final products = compras.getProducts();
    return Scaffold(
      appBar: AppBar(title: Text("Nueva Compra"),),
      body:  Stack(
          children: [
            SingleChildScrollView(
              child:
              Column(
                children: [

                  ListTile(
                    onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProveedorSearch()));
                    },
                    minVerticalPadding: 10.0,
                    tileColor: Color(0xfff6f5f5),
                    title: Text(compras.getProveedor().nombreCompleto),
                    leading: CircleAvatar(child: Text(compras.getProveedor().nombreCompleto.substring(0,1))),
                    trailing:IconButton(icon: Icon(Icons.remove_circle,color: Colors.red,), onPressed: (){
                      compras.proveedor=Persona(64,"Varios","","","","","","","","","","");
                    }),
                  )
                  ,
                  ListTile(
                    minVerticalPadding: 10.0,
                    tileColor: Color(0xfff6f5f5),
                    title:  Center(child: Text("Añadir Productos")),
                    trailing: IconButton(
                        onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>productSearch(false)));
                        },
                        icon:Icon(Icons.add_circle_outlined,color: Colors.green,size: 30.0,)),
                  ),
                  Column(
                     children: products.map((product) =>
                         Container(
                           padding: EdgeInsets.all(5.0),
                           margin: EdgeInsets.all(8.0),

                           width: MediaQuery.of(context).size.width*0.9,
                           decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(15.0)

                           ),
                           child: Stack(
                               children: [
                                 Container(alignment: Alignment.topRight, child: IconButton(icon: Icon(Icons.remove_circle,color: Colors.red,), onPressed: (){
                                   compras.remove(product);
                                 })),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     Expanded(
                                         flex: 1,
                                         child: Image.network(product.url)),
                                     Expanded(
                                       flex: 4,
                                       child: Container(
                                         padding: EdgeInsets.all(8.0),
                                         child: Column(
                                           mainAxisAlignment:MainAxisAlignment.start,
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text(product.productName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
                                             Text("Costo :s/ "+product.precioCosto.toString()),
                                             Row(
                                               mainAxisAlignment: MainAxisAlignment.start,
                                               children: [
                                                 Text("Cantidad :  "),
                                                 Container(width: 20,
                                                   child: TextField(
                                                       textAlign: TextAlign.center,
                                                       decoration: new InputDecoration(
                                                         isDense: true,                      // Added this
                                                         contentPadding: EdgeInsets.all(0.0),  // Added this//fillColor: Colors.green
                                                       ),
                                                       style: TextStyle(fontSize: 14.0),
                                                       onChanged: (input){
                                                         if(input!=""){
                                                         compras.updateCantidad(product, int.parse(input));}
                                                       },
                                                       keyboardType: TextInputType.number,  controller: TextEditingController()..text = compras.getCantidad(product).toString()),
                                                 ),

                                               ],
                                             ),
                                             Row(
                                               mainAxisAlignment: MainAxisAlignment.start,
                                               children: [
                                                 Text("Subtotal:  ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                 Text("S/"+(product.cantidad*product.precioCosto).toString(),style: TextStyle(fontSize: 14.0),),
                                               ],
                                             )
                                           ],
                                         ),
                                       ),
                                     )
                                   ],
                                 ),]
                           ),
                         )

                     ).toList()
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height:160.0,
                  )

                ],
              ),
            ),
          ]

      ),

        bottomSheet: Container(
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.all(5.0),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector(),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Text("Total  S/ "+compras.getTotal().toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0))],),
                      ],
                    ),
                    Spacer(),
                    Container( margin: EdgeInsets.only(right: 20.0), alignment: Alignment.centerRight, child: ElevatedButton(child: Text("PROCEDER"),
                      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30.0,vertical: 20.0))),
                      onPressed:press ? (){
                      setState(() {
                        press= false;
                      });
                        var products = [];
                        for (var prop in compras.getProducts()) {
                          var product = {"idProducto":prop.id,"costo":prop.precioCosto,"cantidad":prop.cantidad,"subTotal":prop.precioCosto*prop.cantidad};
                          products.add(product);
                        }
                      compras.sendData(products).then((correct) {
                        if(correct){
                          Navigator.of(context).pop();
                          comprasList.name="";
                        }
                        setState(() {
                          press=true;
                        });
                      });
                      }:null
                    )
                    ),
                  ]
              ),
            ],
          ),
        )
    );
  }
}

class Selector extends StatefulWidget {
  const Selector({Key key}) : super(key: key);

  @override
  _SelectorState createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  String _chosenValue='D.Interno';

  @override
  Widget build(BuildContext context) {
    final compras = Provider.of<Comprasprov>(context);

    return Row(

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
              _chosenValue = value;
              compras.tipoDocumento=value;
            });

          },
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.3,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              labelText: "Numero ",
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
            onChanged: (input){
              compras.numeroDocumento=input;
            },
          ),
        )
      ],
    );
  }
}

