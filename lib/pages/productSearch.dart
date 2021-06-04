import 'package:flutter/material.dart';
import 'package:mis_ventas/SearchFormProduct.dart';
import 'package:mis_ventas/provider/BusquedaProv.dart';
import 'package:provider/provider.dart';
import '../CardComponent.dart';



class productSearch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final busqueda = Provider.of<BusquedaProv>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Busqueda de Producto"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.01),
              margin: EdgeInsets.all(10.0),
              //height: MediaQuery.of(context).size.height*0.1,
              child: SearchFormProduct()),
          Expanded(
            child: FutureBuilder(
                future: busqueda.getproducts('A'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data;
                    return ListView(children: data.map((prod) => CardComponent(prod)).toList());
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text("Error");}
                  return Center(child: CircularProgressIndicator(),);
                }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
    );
  }
}