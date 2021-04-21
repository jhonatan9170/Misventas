import 'package:flutter/material.dart';
import 'package:mis_ventas/ClientCard.dart';
import 'package:mis_ventas/SearchForm.dart';


class ClientsSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:  AppBar(title: Center(child: Text("Busqueda de Clientes")),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchForm(),
            ClientCard(),

          ],
        ),
      ),

    );
  }
}
