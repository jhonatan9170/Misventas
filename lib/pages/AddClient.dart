
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mis_ventas/provider/AddPersonProv.dart';
import 'package:mis_ventas/provider/ClientSearchProv.dart';
import 'package:provider/provider.dart';

class AddClient extends StatefulWidget {
  const AddClient({Key key}) : super(key: key);

  @override
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  bool press = false;
  String _chosenValue='NATURAL';
  bool esProveedor=false;
  @override
  Widget build(BuildContext context) {
    final client = Provider.of<AddPersonaProv>(context);
    final clientes = Provider.of<ClientSearchProv>(context);
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
                client.apellidos=input;
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
                client.nombres=input;
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
                 client.dni=input;
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
                client.razonSocial=input;
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
                client.nombreComercial=input;
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
                client.ruc=input;
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
                      client.esNatural();
                    }else{
                      client.esJuridica();
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
                Text("ES PROVEEDOR?  "),
                esProveedor ? Text(" SI  ") : Text(" NO  ") ,
                Switch(value: esProveedor, onChanged: (value){
                  setState(() {
                    esProveedor=value;
                    print(value);
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
                 client.telFijo=input;
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
                  client.celular=input;
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
                setState(()=> press =true);
                if(esProveedor){
                  client.sendData('AMBOS').then((value)  {
                    client.clear();
                    setState(()=> press =false);
                    clientes.name="";
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                        msg: "Cliente a??adido",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );

                  });
                }else{
                  client.sendData('CLIENTE').then((value) {
                    client.clear();
                    setState(()=> press =false);
                    clientes.name="";
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                        msg: "Cliente a??adido",
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
