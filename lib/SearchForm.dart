import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/BusquedaProv.dart';

class SearchForm extends StatefulWidget {
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
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
