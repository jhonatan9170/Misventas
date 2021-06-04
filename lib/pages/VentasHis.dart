import 'package:flutter/material.dart';
import 'package:mis_ventas/VentasComponent.dart';
import 'package:mis_ventas/pages/Venta.dart';

class VentasHis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: VentasComponent(),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),
      onPressed: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>Venta())
        );
      },
      ),
    );
  }
}
