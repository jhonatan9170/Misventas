import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mis_ventas/Login/Registro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  static String id = 'login_page';
  String url = 'https://www.mintformations.co.uk/blog/wp-content/uploads/2020/05/shutterstock_583717939.jpg';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool ishidden = true;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Center(
        child: Column(
          children: [
            Flexible(child: Image.network('https://cdn.logo.com/hotlink-ok/logo-social.png',height: 300.0),),
            SizedBox(height: 15.0,),
            _userTextField(),
            SizedBox(height: 15.0,),
            _passwordField(),
            SizedBox(height: 20.0,),
            _bottonLogin(),
            SizedBox(height: 20.0,),
            //Text("¿Aun no tiene cuenta?",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,),),
            TextButton(child: Text("¿No tienes cuenta? Registrate",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,),),onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Registro()),
              );
            },),
          ],
        ),

        
      )),
    ) ;
  }
  Widget _userTextField(){
    return StreamBuilder(builder: (context,snapshot){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          controller: emailController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            icon: Icon(Icons.person),
            labelText: 'Usuario',
            hintText: 'Usuario'

          ),
        ),

      );
    });
  }

  Widget _passwordField(){
    return StreamBuilder(builder: (BuildContext context,AsyncSnapshot snapshot){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          controller: passwordController,
          keyboardType: TextInputType.text,
          obscureText: ishidden,
          decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Contraseña',
              hintText: 'contraseña',
              suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye_outlined),onPressed: (){setState(() {
                ishidden=!ishidden;
              });})

          ),
        ),

      );
    });
  }




  Widget _bottonLogin(){
      return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0,vertical:15.0),
          child: Text('Iniciar Sesion',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        elevation: 10.0,
        color: Colors.amber,
        onPressed: _isLoading ? null :() {
          FocusScope.of(context).unfocus();
          setState(() {
            _isLoading = true ;
          });
          signIn(emailController.text, passwordController.text).then((value) {
            setState(() {
              _isLoading = false;
            });

          });
        },
      );
  }
  Future <void> signIn(String email, pass) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = {
      'usuario': email,
      'password': pass
    };

    var url = Uri.parse('https://misventas.azurewebsites.net/api/checkLogin');
    var response = await http.post(url, body: jsonEncode(data),headers: headers);
      var jsonResponse = jsonDecode(response.body);
      if(jsonResponse!=0) {
        sharedPreferences.setString("token", jsonResponse['token']);
        sharedPreferences.setInt("idUsuario", jsonResponse['idUsuario']);
        sharedPreferences.setInt("idEmpresa", jsonResponse['idEmpresa']);
        sharedPreferences.setString("usuario", jsonResponse['usuario']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false);
      }else {
        Fluttertoast.showToast(
            msg: "Usuario o Contraseña Incorrecta",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }

      return;
  }

}

