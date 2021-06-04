import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
class rucModel{
  String ruc = "";
  String direccion ="";
  String razon = "";
  Future<void> set(String ruc)async {

    var url = Uri.parse('https://api.apis.net.pe/v1/ruc?numero=$ruc');
    var response = await get(url);
    print(response);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      this.ruc =ruc;
      this.razon = jsonData["nombre"];
      this.direccion = jsonData["direccion"];
    } else {
      this.ruc="";
      this.razon = "";
      this.direccion = "";
      Fluttertoast.showToast(
          msg: "RUC no valido",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }
  }
}