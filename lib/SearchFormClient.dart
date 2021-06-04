import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/ClientSearchProv.dart';

class SearchFormClient extends StatefulWidget {
  @override
  _SearchFormClientState createState() => _SearchFormClientState();

}

class _SearchFormClientState extends State<SearchFormClient> {
  @override
  Widget build(BuildContext context) {
    final clientSearch = Provider.of<ClientSearchProv>(context);
    return TextField(
      onChanged: (input)=>clientSearch.name=input,
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
