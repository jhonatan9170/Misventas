import 'package:flutter/material.dart';
import 'package:mis_ventas/pages/Ventas.dart';
import 'package:mis_ventas/provider/BusquedaProv.dart';
import 'package:mis_ventas/provider/Ventasprov.dart';
import 'package:provider/provider.dart';
import 'provider/ClientSearchProv.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BusquedaProv>(create: (_)=>BusquedaProv(),),
        ChangeNotifierProvider<Ventasprov>(create: (_)=>Ventasprov(),),
        ChangeNotifierProvider<ClientSearchProv>(create: (_)=>ClientSearchProv(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor:Color(0xFFf3f4ed),
          primarySwatch: Colors.blue,
        ),
        home: Ventas(),
      ),
    );
  }
}



