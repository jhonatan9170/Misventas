import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mis_ventas/provider/AddPersonProv.dart';
import 'package:mis_ventas/provider/ProveedorSearchProv.dart';
import 'package:provider/provider.dart';

class ProveedorAdd extends StatefulWidget {

  @override
  _ProveedorAddState createState() => _ProveedorAddState();
}

class _ProveedorAddState extends State<ProveedorAdd> {
  bool press = false;
  String _chosenValue='NATURAL';
  bool esCliente=false;
  @override
  Widget build(BuildContext context) {
    final proveedor = Provider.of<AddPersonaProv>(context);
    final proveedores = Provider.of<ProveedorSearchProv>(context);
    Widget NaturalForm(){
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                labelText: "Apellidos",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                //fillColor: Colors.green
              ),
              onChanged: (input){
                proveedor.apellidos=input;
              },
            ),

          ),

          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                labelText: "Nombres",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                //fillColor: Colors.green
              ),
              onChanged: (input){
                proveedor.nombres=input;
              },
            ),

          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                labelText: "DNI",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                //fillColor: Colors.green
              ),
              keyboardType: TextInputType.number,
              onChanged: (input){
                  proveedor.dni=input;

              },
            ),

          ),


        ],
      );
    }



    Widget JuridicaForm(){
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                labelText: "Razon Social",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                //fillColor: Colors.green
              ),
              onChanged: (input){
                proveedor.razonSocial=input;
              },
            ),

          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                labelText: "Nombre Comercial",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                //fillColor: Colors.green
              ),
              onChanged: (input){
                proveedor.nombreComercial=input;
              },
            ),

          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                labelText: "RUC",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                //fillColor: Colors.green
              ),
              keyboardType: TextInputType.number,
              onChanged: (input){
                proveedor.ruc=input;
              },
            ),

          ),


        ],
      );
    }


    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("PERSONA  "),
                DropdownButton<String>(
                  focusColor:Colors.white,
                  value: _chosenValue,
                  //elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor:Colors.black,
                  items: <String>[
                    'NATURAL',
                    'JURIDICA'
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
                    if(value=="NATURAL"){
                      proveedor.esNatural();
                    }else{
                      proveedor.esJuridica();
                    }
                    setState(() {
                      _chosenValue = value;
                    });
                  },
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ES Cliente?  "),
                esCliente ? Text(" SI  ") : Text(" NO  ") ,
                Switch(value: esCliente, onChanged: (value){
                  setState(() {
                    esCliente=value;
                  });

                })
              ],
            ),
            _chosenValue=='NATURAL' ? NaturalForm() : JuridicaForm(),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                  labelText: "Telefono Fijo",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.number,
                onChanged: (input){
                  proveedor.telFijo=input;
                },
              ),

            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: new InputDecoration(
                  labelText: "Celular",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  //fillColor: Colors.green
                ),
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                keyboardType: TextInputType.number,
                onChanged: (input){
                  proveedor.celular=input;
                },
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              onPressed: press ? null :  () {
                setState(() => press = true );
                if(esCliente){
                  proveedor.sendData('AMBOS').then((value)  {
                    setState(() => press = false );
                    proveedores.name="";
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                        msg: "Proveedor añadido",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );

                  });
                }else{
                  proveedor.sendData('PROVEEDOR').then((value) {
                    setState(() => press = false );
                    proveedores.name="";
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                        msg: "Proveedor añadido",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );

                  } );
                }

              },
              child: Container(padding:EdgeInsets.symmetric(vertical: 12.0,horizontal:40.0 ),child: Text('AGREGAR',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),)),
            ),
          ],
        ),

      ),
    );

  }
}
