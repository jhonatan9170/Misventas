import 'package:flutter/material.dart';
import 'package:mis_ventas/Login/RegisterProv.dart';
import 'package:mis_ventas/pages/ClientList.dart';
import 'package:mis_ventas/pages/Compras.dart';
import 'package:mis_ventas/pages/ComprasList.dart';
import 'package:mis_ventas/pages/ListProduct.dart';
import 'package:mis_ventas/pages/VentasHis.dart';
import 'package:mis_ventas/provider/AddClientProv.dart';
import 'package:mis_ventas/provider/AddProducProv.dart';
import 'package:mis_ventas/provider/BusquedaProv.dart';
import 'package:mis_ventas/provider/DetalleVentaProv.dart';
import 'package:mis_ventas/provider/VentasListProv.dart';
import 'package:mis_ventas/provider/Ventasprov.dart';
import 'package:provider/provider.dart';
import 'Login/Login.dart';
import 'provider/ClientSearchProv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/ComprasProv.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  SharedPreferences sharedPreferences;

  Future<bool> checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null) {
      return false;
    }else{
      return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RegisterProv>(create: (_)=>RegisterProv(),),
        ChangeNotifierProvider<BusquedaProv>(create: (_)=>BusquedaProv(),),
        ChangeNotifierProvider<Ventasprov>(create: (_)=>Ventasprov(),),
        ChangeNotifierProvider<ClientSearchProv>(create: (_)=>ClientSearchProv(),),
        ChangeNotifierProvider<VentasListProv>(create: (_)=>VentasListProv(),),
        ChangeNotifierProvider<DetalleVentaProv>(create: (_)=>DetalleVentaProv(),),
        ChangeNotifierProvider<AddProductProv>(create: (_)=>AddProductProv(),),
        ChangeNotifierProvider<AddClientProv>(create: (_)=>AddClientProv(),),
        ChangeNotifierProvider<Comprasprov>(create: (_)=>Comprasprov(),),




      ],
      child: MaterialApp(
        title: 'Mis_ventas',
        theme: ThemeData(
          scaffoldBackgroundColor:Color(0xFFf3f4ed),
          primarySwatch: Colors.blue,
        ),
        home:FutureBuilder(
            future: checkLoginStatus(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                if(snapshot.data){
                  return HomePage();
                }else{
                  return Login();
                }
              }else{
                return Login();
              }

        })
      ),
    );
  }
}
class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Ventas", Icons.point_of_sale_sharp),
    new DrawerItem("Productos", Icons.add_business),
    new DrawerItem("Clientes", Icons.people_alt_rounded),
    new DrawerItem("Compras", Icons.wallet_travel_sharp)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;
  int _selectedDrawerIndex = 0;
  String _userLabel ="";

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return VentasHis();
      case 1:
        return ListProduct();
      case 2:
        return ClientList();
      case 3:
        return ComprasList();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
 void initState()  {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        _userLabel=value.getString("usuario");
      });

    });

  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                currentAccountPicture:CircleAvatar(child: Text(_userLabel!=""?_userLabel[0]:"",style: TextStyle(fontSize: 30),),),
                accountName: Text(_userLabel),
             //   accountEmail:Text("john@misventas.com")
            ),
            new Column(children: drawerOptions),
            Expanded(child: SizedBox()),
            new ListTile(
              leading: Icon(Icons.logout),
              title: new Text("Salir"),
              onTap: ()async {
                sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Login()), (Route<dynamic> route) => false);
              } ,
            )
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}




