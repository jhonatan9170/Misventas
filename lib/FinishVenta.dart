import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/Ventasprov.dart';

class FinishVenta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ventas = Provider.of<Ventasprov>(context);
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.0),
      height: 180.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //IconButton(icon: Icon(Icons.), onPressed: (){}),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Total   ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0)),Text("S/"+ventas.getTotal().toString(),style: TextStyle(fontSize: 18.0))],),
          Container(
            margin: EdgeInsets.all(3.0),
            width: MediaQuery.of(context).size.width*0.8,
            height: 40.0,
            child: TextField(
              keyboardType: TextInputType.number,
              onSubmitted: (i){
                ventas.pago=double.parse(i);
              },
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                labelText: "Paga con ",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center, children: [Text("Vuelto ",style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 18.0),), Text("S/"+ventas.getVuelto(),style: TextStyle(fontSize: 18.0))],
          ),
          ElevatedButton(child: Text("PAGAR"),
            style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50.0))),
          onPressed: (){},
          ),
        ]


      ),
    );
  }
}
