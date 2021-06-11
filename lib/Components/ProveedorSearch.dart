
import 'package:flutter/material.dart';
import 'package:mis_ventas/provider/ClientSearchProv.dart';
import 'package:mis_ventas/provider/ComprasProv.dart';
import 'package:mis_ventas/provider/ProveedorSearchProv.dart';
import 'package:provider/provider.dart';

class ProveedorSearch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agregar Proveedor"),),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: SearchFormProveedor(context)
          ),
          Expanded(child: ProveedorCard(context)),
        ],
      ),
    );


  }

  Widget SearchFormProveedor(context){
    final proveedorSearch = Provider.of<ClientSearchProv>(context);
    return TextField(
      onChanged: (input)=>proveedorSearch.name=input,
      textAlign: TextAlign.center,
      decoration: new InputDecoration(
        labelText: "Busqueda",
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ), //fillColor: Colors.green
      ),
      style: new TextStyle(
        fontFamily: "Poppins",
      ),
    );

  }
  Widget ProveedorCard(context){
    final proveedor = Provider.of<ProveedorSearchProv>(context);
    final compras = Provider.of<Comprasprov>(context);
    return  FutureBuilder(
        future: proveedor.getProveedores('A'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data;
            return ListView(children: data.map((proveedor) =>
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 16.0),
                  child: ListTile(
                      onTap: (){
                          compras.proveedor=proveedor;
                          Navigator.pop(context);
                      },
                      minVerticalPadding: 10.0,
                      tileColor: Color(0xfff6f5f5),
                      title: Text(proveedor.nombreCompleto),
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
}

