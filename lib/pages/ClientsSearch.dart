import 'package:flutter/material.dart';
import 'package:mis_ventas/ClientCard.dart';
import 'package:mis_ventas/SearchFormClient.dart';

import 'AddClient.dart';



class ClientsSearch extends StatefulWidget {
  bool _isGeneral;
  ClientsSearch(this._isGeneral);
  @override
  _ClientsSearchState createState() => _ClientsSearchState();
}

class _ClientsSearchState extends State<ClientsSearch> {
  String estado = 'A';
  String _chosenValue='ACTIVOS';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            !widget._isGeneral ? AppBar(title:Center(child: Text("Agregar Cliente"))):Text(""),
            Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container (child: SearchFormClient(),
                      width: widget._isGeneral ? MediaQuery.of(context).size.width*0.65 :MediaQuery.of(context).size.width*0.9,
                    ),
                    widget._isGeneral ? DropdownButton<String>(
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
                     ):Text(""),

                    ])
            ),
            ClientCard(estado,widget._isGeneral),
          ],
        ),
      ),
       floatingActionButton: !widget._isGeneral ?  Text(""):
      FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>AddClient()));
      })
      
      
    );
  }
}
