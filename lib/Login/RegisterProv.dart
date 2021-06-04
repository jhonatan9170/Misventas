import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mis_ventas/Login/dniModel.dart';
import 'package:mis_ventas/Login/rucModel.dart';
import 'package:email_validator/email_validator.dart';


class RegisterProv with ChangeNotifier {
  //validates
  bool uservalidate = false;
  bool _emailValidate = false;
  String usuario;
  String contrasena;
  rucModel _ruc;
  dniModel _dni;
  String nombreComercial;
  String celular;
  String telFijo;
  String _email ;

  bool _passValidate = false;
  bool _rucValidate = false;
  bool _dniValidate = false;
  bool _nComercialValidate =false;
  String _errorPass = "" ;

  bool get passvalidate =>  _passValidate;
  bool get dniValidate => _dniValidate;
  String get errorPass => _errorPass;
  bool get rucValidate => _rucValidate;
  bool get nComercialValidate => _nComercialValidate;
  bool get emailValidate => _emailValidate;
  bool get validate => _rucValidate&&_nComercialValidate&&_emailValidate&uservalidate&&_passValidate&&_dniValidate;

  void setUserValidate(bool validate){
    uservalidate=validate;
    notifyListeners();
  }
   void setPassValidate(String pass1,String pass2){
    if(pass1==pass2) {
      if(pass2.length<8){
        this._passValidate = false;
        this._errorPass = "Contraseñas minimo 8 caracteres";
      }else{
        this._passValidate = true;
        this.contrasena =pass1;
      }
    }else{
      this._passValidate = false;
      this._errorPass = "Contraseñas no coinciden";
    }
    notifyListeners();
  }

  void set ruc(rucModel ruc){
    if(ruc.razon!=""&&ruc.razon!=null) {
      this._ruc=ruc;
      _rucValidate = true;
    }else {
      _rucValidate=false;
    }
    notifyListeners();

  }
  void set dni(dniModel dni){
    if(dni.dni!=""&&dni.dni!=null) {
      this._dni=dni;
      _dniValidate = true;
    }else {
      _dniValidate=false;
    }
    notifyListeners();
  }
  void setnComercialValidate(bool nComercialValidate) {
    this._nComercialValidate=nComercialValidate;
    notifyListeners();
  }
void setEmail(String email) {
    if(EmailValidator.validate(email)){
      this._email=email;
      _emailValidate=true;
    }else{
      _emailValidate=false;
    }
    notifyListeners();
}



  Future<bool> sendData() async {
    var url = Uri.parse('https://misventas.azurewebsites.net/api/empresa');
    var body =
     {
      "usuario" : usuario,
      "contrasena" : contrasena,
      "apellidos" :_dni.apellidos,
      "nombres":_dni.nombre,
      "nombreCompleto": _dni.nombreCompleto,
      "telFijo" : telFijo,
      "celular":celular,
      "dni":_dni.dni,
      "razonSocial":_ruc.razon,
      "nombreComercial" : nombreComercial,
      "direccion":_ruc.direccion,
      "RUC" :_ruc.ruc


    };

    print(jsonEncode(body));
    Map<String, String> headers = {"Content-type": "application/json"};
    var response = await http.post(
        url, headers: headers, body: jsonEncode(body));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return 200==response.statusCode ;
  }


  void setUsuario(String usuario) {
    this.usuario = usuario;
    notifyListeners();
    checkUser();
  }
  void vaciarForm(){
     uservalidate = false;
     _emailValidate = false;
    usuario=null;
     contrasena=null;
     _ruc=null;
     _dni=null;
    nombreComercial=null;
     celular=null;
    telFijo=null;
     _email=null;

    _passValidate = false;
     _rucValidate = false;
     _dniValidate = false;
     _nComercialValidate =false;
     _errorPass = "" ;

  }
   checkUser() async{
    var url = Uri.parse('https://misventas.azurewebsites.net/api/checkUser?usuario='+usuario.toUpperCase());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      if(jsonData==0){
        setUserValidate(true);
      }else {
        setUserValidate(false);
      }
    } else {
      throw Exception("Falló la conexión");
    }
  }
}




