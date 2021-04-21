import 'package:flutter/material.dart';
import 'package:mis_ventas/SearchForm.dart';


import '../TableComponent.dart';



class productSearch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(child: Text("Busqueda de Producto")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.01),
                margin: EdgeInsets.all(10.0),
                //height: MediaQuery.of(context).size.height*0.1,
                child: SearchForm()),
            Expanded(
              child: TableComponent(),
            )
          ],
        ),
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