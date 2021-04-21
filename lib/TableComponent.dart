import 'package:flutter/material.dart';
import 'package:mis_ventas/CardComponent.dart';
import 'package:mis_ventas/provider/BusquedaProv.dart';
import 'package:provider/provider.dart';

class TableComponent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final busqueda = Provider.of<BusquedaProv>(context);
    return ListView(

      children: [
        Center(
          child:FutureBuilder(
            future: busqueda.getproducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List data = snapshot.data;
                return Wrap(children: data.map((prod) => CardComponent(prod)).toList());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("Error");}
              return Center(child: CircularProgressIndicator(),);
    }
    )

          ),
      ],
    );
  }
}
