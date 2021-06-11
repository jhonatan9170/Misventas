import 'package:flutter/material.dart';
import 'package:mis_ventas/pages/ProveedorAdd.dart';
import 'package:mis_ventas/provider/ProveedorSearchProv.dart';
import 'package:provider/provider.dart';

import '../ProveedorCard.dart';

class ProveedorList extends StatefulWidget {


  @override
  _ProveedorListState createState() => _ProveedorListState();
}

class _ProveedorListState extends State<ProveedorList> {
  String estado = 'A';
  String _chosenValue='ACTIVOS';
  @override
  Widget build(BuildContext context) {
    final proveedorList = Provider.of<ProveedorSearchProv>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8.0),
                  width: MediaQuery.of(context).size.width*0.5,
                  child: TextField(
                    onChanged: (input)=>proveedorList.name=input,
                    textAlign: TextAlign.center,
                    decoration: new InputDecoration(
                      labelText: "Busqueda",
                      fillColor: Colors.white,
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(5),  // Added this
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ), //fillColor: Colors.green
                    ),
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                DropdownButton<String>(
                  focusColor:Colors.white,
                  value: _chosenValue,
                  //elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor:Colors.black,
                  items: <String>[
                    'ACTIVOS',
                    'INACTIVOS',
                    'TODOS'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style:TextStyle(color:Colors.black),),
                    );
                  }).toList(),
                  hint:Text(
                    "NATURAL",
                    style: TextStyle(
                      fontSize: 14,),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      switch(value) {
                        case 'ACTIVOS':
                          estado='A';
                          break;
                        case 'INACTIVOS':
                          estado='I';
                          break;
                        default :
                          estado='T';
                          break;
                      }
                      _chosenValue = value;
                    });
                  },
                ),
              ],
            ),
            Expanded(child: ProveedorCard(estado))
          ],

        ),
      ),
      floatingActionButton:FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>ProveedorAdd()));
      }),
    );
  }
}
