import 'package:flutter/material.dart';
import 'package:mis_ventas/pages/AddProduct.dart';
import 'package:mis_ventas/pages/ClientsSearch.dart';
import 'package:mis_ventas/pages/VentasHis.dart';
import 'package:mis_ventas/provider/AddClientProv.dart';
import 'package:mis_ventas/provider/AddProducProv.dart';
import 'package:mis_ventas/provider/BusquedaProv.dart';
import 'package:mis_ventas/provider/DetalleVentaProv.dart';
import 'package:mis_ventas/provider/VentasListProv.dart';
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
        ChangeNotifierProvider<VentasListProv>(create: (_)=>VentasListProv(),),
        ChangeNotifierProvider<DetalleVentaProv>(create: (_)=>DetalleVentaProv(),),
        ChangeNotifierProvider<AddProductProv>(create: (_)=>AddProductProv(),),
        ChangeNotifierProvider<AddClientProv>(create: (_)=>AddClientProv(),),



      ],
      child: MaterialApp(
        title: 'Mis_ventas',
        theme: ThemeData(
          scaffoldBackgroundColor:Color(0xFFf3f4ed),
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
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
    new DrawerItem("Clientes", Icons.people_alt_rounded)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return VentasHis();
      case 1:
        return AddProduct();
      case 2:
        return ClientsSearch(true);
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
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
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: Center(child: Text(widget.drawerItems[_selectedDrawerIndex].title)),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                currentAccountPicture:CircleAvatar(child: Text("J",style: TextStyle(fontSize: 30),),),
                accountName: Text("John Doe"), 
                accountEmail:Text("john@misventas.com") ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}




