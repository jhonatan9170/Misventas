import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mis_ventas/Login/RegisterProv.dart';
import 'package:mis_ventas/Login/dniModel.dart';
import 'package:mis_ventas/Login/rucModel.dart';
import 'package:provider/provider.dart';

import 'Login.dart';

class Registro extends StatefulWidget {
  static String id = 'login_page';
  String url = 'https://www.mintformations.co.uk/blog/wp-content/uploads/2020/05/shutterstock_583717939.jpg';
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  bool isSending = false;
  rucModel ruc = rucModel();
  dniModel dni = dniModel();
  String rucnumber ;
  String dniNumber ;
  final _passContooller = TextEditingController();

  @override
  void dispose() {
    _passContooller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: Image.network('https://cdn.logo.com/hotlink-ok/logo-social.png',height: 200.0),),
              SizedBox(height: 15.0,),

              _RucField(),
              SizedBox(height: 15.0,),
              noEditableField("Razon Social",ruc==null ? "": ruc.razon),
              SizedBox(height: 15.0,),
              _nombreComercialField(),
              SizedBox(height: 15.0,),
              _emailField(),
              SizedBox(height: 15.0,),

              _userTextField(),
              SizedBox(height: 15.0,),
              _passwordField(),
              SizedBox(height: 15.0,),
              _confirmPasswordField(),
              SizedBox(height: 15.0,),
              _dniField(),
              SizedBox(height: 15.0,),
              noEditableField("Nombre ", dni==null ? "": dni.nombreCompleto),
              SizedBox(height: 15.0,),
              _celularField(),
              SizedBox(height: 15.0,),
              _telFijoField(),

              SizedBox(height: 20.0,),
              _bottonLogin(),
              SizedBox(height: 20.0,),
            ],
          ),
        ),
      )),
    ) ;
  }
  Widget _userTextField(){
    final registro = Provider.of<RegisterProv>(context);
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Usuario',
              hintText: 'Usuario',
            errorText:!registro.uservalidate ? 'error' :null,
            suffixIcon: !registro.uservalidate ? Icon(Icons.cancel_outlined,color: Colors.red,) :Icon(Icons.check,color: Colors.green,)
          ),
          onChanged: (input){
            registro.setUsuario(input);
          },
        ),
      );
  }

  Widget _passwordField(){
    final registro = Provider.of<RegisterProv>(context);
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          obscureText: true,
          controller: _passContooller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            errorText:!registro.passvalidate ? registro.errorPass:null,
              icon: Icon(Icons.lock),
              labelText: 'Contraseña',
            hintText: 'contraseña',
          ),
        ),
      );

  }
  Widget _confirmPasswordField(){
      final registro = Provider.of<RegisterProv>(context);
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            errorText:!registro.passvalidate ? registro.errorPass:null,
              icon: Icon(Icons.lock),
              labelText: 'Confirmar contraseña',
              hintText: 'Confirmar contraseña',
          ),

          onChanged: (input){
            registro.setPassValidate(_passContooller.text,input);
          },
        ),


      );
  }

  Widget _RucField(){
    final registro = Provider.of<RegisterProv>(context);
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.number,
          onChanged: (input){
            rucnumber=input;
          },
          decoration: InputDecoration(
            errorText: registro.rucValidate ? null : "inserte RUC valido",
              icon: Icon(Icons.insert_drive_file),
              labelText: 'RUC',
              hintText: 'RUC',
            suffixIcon: IconButton(icon: Icon(Icons.search),onPressed:isSending ? null : (){
              submitRuc().then((value){
                registro.ruc=ruc;
                setState(() {
                  isSending = false;
                });
              });
            },)
          ),
          onEditingComplete: (){
            submitRuc().then((value){
              registro.ruc=ruc;
              setState(() {
                isSending = false;
              });
            });

          },
        ),
      );
  }
  Widget _dniField(){
    final registro = Provider.of<RegisterProv>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.number,
        onChanged: (input){
          dniNumber=input;
        },
        decoration: InputDecoration(
            icon: Icon(Icons.insert_drive_file),
            labelText: 'DNI',
            hintText: 'DNI',
            errorText:registro.dniValidate ? null:"Error" ,
            suffixIcon: IconButton(icon: Icon(Icons.search),onPressed:isSending ? null : (){
              submitDNI().then((value) {
                registro.dni=dni;
                setState(() {
                  isSending = false;
                });
              } );
            },)
        ),
        onEditingComplete: (){
          submitDNI().then((value) {
            registro.dni=dni;
            setState(() {
              isSending = false;
            });
          } );
        },
      ),
    );
  }
  Widget _nombreComercialField(){
    final registro = Provider.of<RegisterProv>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        onChanged: (input){
          if(input!=""){
              registro.setnComercialValidate(true);
              registro.nombreComercial=input;
          }
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          errorText: registro.nComercialValidate ? null: "error",
            icon: Icon(Icons.business_sharp),
            labelText: 'nombreComercial',
            hintText: 'nombreComercial'
        ),
      )
    );
  }

  Widget _celularField(){
    final registro = Provider.of<RegisterProv>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        onChanged: (input){
          registro.celular=input;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            icon: Icon(Icons.phone_android_rounded),
            labelText: 'Celular',
            hintText: 'Celular'
        ),
      ),
    );
  }
  Widget _telFijoField(){
    final registro = Provider.of<RegisterProv>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        onChanged: (input){
          registro.telFijo = input;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            icon: Icon(Icons.phone),
            labelText: 'Telefono Fijo',
            hintText: 'TeleFono Fijo'
        ),
      ),
    );
  }

  Widget _emailField(){
    final registro = Provider.of<RegisterProv>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        onChanged: (input){
          registro.setEmail(input);
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          errorText: registro.emailValidate?null:"error",
            icon: Icon(Icons.email),
            labelText: 'Email',
            hintText: 'Email'
        ),
      ),
    );
  }
  Widget noEditableField(String fieldname,String field){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          controller: TextEditingController()..text =field,
          maxLines: 2,
          readOnly: true,
          decoration: InputDecoration(
            labelText: fieldname,
            hintText: fieldname,
            icon: Icon(Icons.dashboard),
          ),
        ),

      );
  }


  Widget _bottonLogin(){
    final registro = Provider.of<RegisterProv>(context);
    return StreamBuilder(builder: (BuildContext context,AsyncSnapshot snapshot){
      return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0,vertical:15.0),
          child: Text('Registrarse',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        elevation: 10.0,
        color: Colors.amber,
        onPressed: !registro.validate||isSending ? null : (){
          setState(() {isSending = true;});
          registro.sendData().then((value) {
            if(value){
              Fluttertoast.showToast(
                  msg: "usuario agregado",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()),);
              registro.vaciarForm();
            }else {
              Fluttertoast.showToast(
                  msg: "Error en el envio",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              setState(() {isSending = false;});
            }

          });
        },
      );
    });
  }

  Future<void> submitRuc () async {

    FocusScope.of(context).unfocus();
    setState(() {isSending = true;});
    await ruc.set(rucnumber);
  }
  Future<void>  submitDNI () async {
    FocusScope.of(context).unfocus();
    setState(() {isSending = true;});
    await dni.set(dniNumber);
  }
}

