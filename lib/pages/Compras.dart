
import 'package:flutter/material.dart';
import 'package:mis_ventas/Components/FinishCompra.dart';
import 'package:mis_ventas/provider/ComprasProv.dart';
import 'package:mis_ventas/provider/Ventasprov.dart';
import 'package:provider/provider.dart';

import 'ClientsSearch.dart';

class Compras extends StatelessWidget {
  const Compras({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final compras = Provider.of<Comprasprov>(context);
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>ProveedorSeach())
                      );
                    },
                    minVerticalPadding: 10.0,
                    tileColor: Color(0xfff6f5f5),
                    title: Text(ventas.getCLiente().nombreCompleto),
                    leading: CircleAvatar(child: Text(ventas.getCLiente().nombreCompleto.substring(0,1))),
                    trailing:IconButton(icon: Icon(Icons.remove_circle,color: Colors.red,), onPressed: (){
                      ventas.cliente=Persona(62,"Varios","","","","","","","","","","");
                    }),
                  )
                  ,
                  ListTile(
                    minVerticalPadding: 10.0,
                    tileColor: Color(0xfff6f5f5),
                    title: Center(child: Text("Añadir Productos")),
                    trailing: IconButton(
                        onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>productSearch())
                          );
                        },
                        icon:Icon(Icons.add_circle_outlined,color: Colors.green,size: 30.0,)),
                  ),
                  Column(
                      children: products.map((producto) => ProductComponent(producto)).toList()
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height:160.0,
                  )

                ],
              ),
            ),
          ]

      ),,





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
                        Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text("Total   "+compras.getTotal().toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),Text("S/",style: TextStyle(fontSize: 15.0))],),
                      ],
                    ),
                    Spacer(),
                    Container( margin: EdgeInsets.only(right: 20.0), alignment: Alignment.centerRight, child: ElevatedButton(child: Text("PROCEDER"),
                      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30.0,vertical: 20.0))),
                      onPressed: (){

                        showModalBottomSheet(shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                            isScrollControlled: true,context: context, builder: (BuildContext bc){
                              return FinishCompra();
                            });
                      },)),
                  ]
              ),
            ],
          ),
        )
    );
  }
}
