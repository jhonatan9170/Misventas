import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/ClientSearchProv.dart';
import 'provider/Ventasprov.dart';

class ClientCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final clientes = Provider.of<ClientSearchProv>(context);
    final venta = Provider.of<Ventasprov>(context);
    return  FutureBuilder(
        future: clientes.getClients(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data;
            return Column(children: data.map((client) =>
                ListTile(
                  onLongPress: (){
                    venta.cliente=client;
                    Navigator.pop(context);
                  },
                  minVerticalPadding: 10.0,
                  tileColor: Color(0xfff6f5f5),
                  title: Center(child: Text(client.nombreCompleto)),
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                      maxWidth: 64,
                      maxHeight: 64,
                    ),
                    child: Image.network(client.urlImage, fit: BoxFit.cover),
                  ),
                )

            ).toList());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Error");}
          return Center(child: CircularProgressIndicator(),);
        });
  }
}
