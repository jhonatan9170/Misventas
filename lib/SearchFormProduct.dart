import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/BusquedaProv.dart';

class SearchFormProduct extends StatefulWidget {
  @override
  _SearchFormProductState createState() => _SearchFormProductState();
}

class _SearchFormProductState extends State<SearchFormProduct> {
  @override
  Widget build(BuildContext context) {
    final busqueda = Provider.of<BusquedaProv>(context);
    return TextField(
      onChanged: (input)=>busqueda.name=input,
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
    );;
  }
}
