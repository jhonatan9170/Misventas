import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mis_ventas/FinishVenta.dart';
import 'package:mis_ventas/Models/Cliente.dart';
import 'package:mis_ventas/ProductComponent.dart';
import 'package:mis_ventas/pages/ClientsSearch.dart';
import 'package:mis_ventas/pages/productSearch.dart';
import 'package:mis_ventas/provider/Ventasprov.dart';
import 'package:provider/provider.dart';

class Venta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ventas = Provider.of<Ventasprov>(context);
    final products = ventas.getProducts();
    return Scaffold(

      bottomSheet: Container(
        alignment: Alignment.center,
        height: 100.0,
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Color(0xFF80d6ff),
            borderRadius: BorderRadius.circular(15.0)

        ),
        child: Stack(
          children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text("SubTotal   ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0)),Text("S/"+ventas.getSubtotal().toString(),style: TextStyle(fontSize: 18.0))],),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text("Descuento   ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0)),Text("S/"+ventas.getDescuento().toString(),style: TextStyle(fontSize: 18.0))],),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text("Total   ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0)),Text("S/"+ventas.getTotal().toString(),style: TextStyle(fontSize: 18.0))],),
          ],
          ),
            Container( margin: EdgeInsets.only(right: 20.0), alignment: Alignment.centerRight, child: ElevatedButton(child: Text("PROCEDER"),
              style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30.0,vertical: 20.0))),
              onPressed: (){
              showModalBottomSheet(shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                  isScrollControlled: true,context: context, builder: (BuildContext bc){
                return FinishVenta();
              });
              },)),
          ]
        ),)
      ,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Center(child: Text("Nueva Venta"))),
      body: Stack(
        children: [
          SingleChildScrollView(
          child:
            Column(
            children: [

              ListTile(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>ClientsSearch(false))
                  );
                },
                minVerticalPadding: 10.0,
                tileColor: Color(0xfff6f5f5),
                title: Text(ventas.getCLiente().nombreCompleto),
                leading: CircleAvatar(child: Text(ventas.getCLiente().nombreCompleto.substring(0,1))),
                trailing:IconButton(icon: Icon(Icons.remove_circle,color: Colors.red,), onPressed: (){
                  ventas.cliente=Cliente(10,"Varios","","","","","","","","","","","");
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

      ),
    );
  }


}



/*


*/