import 'package:flutter/material.dart';
import 'package:mis_ventas/ClientCard.dart';
import 'package:mis_ventas/SearchFormClient.dart';



class ClientsSearch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agregar Cliente"),),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: SearchFormClient()
          ),
          Expanded(child: ClientCard('A',false)),
        ],
      ),
    );
  }
}
