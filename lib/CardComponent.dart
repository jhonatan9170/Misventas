import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mis_ventas/Models/Product.dart';
import 'package:mis_ventas/provider/Ventasprov.dart';
import 'package:provider/provider.dart';

class CardComponent extends StatefulWidget {
  Product _product;
  CardComponent(this._product);

  @override
  _CardComponentState createState() => _CardComponentState();
}

class _CardComponentState extends State<CardComponent> {
  @override
  Widget build(BuildContext context) {
    final venta = Provider.of<Ventasprov>(context);
    return Card(
      child: Column(
        children: [
          Row(
            children:[
              Expanded( flex:3,
                  child:
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          // padding: EdgeInsets.all(8.0),
                           // height:MediaQuery.of(context).size.height*0.15,
                           child: GestureDetector(
                               child: Image.network(widget._product.url,fit:BoxFit.cover,),
                             onTap: (){
                               showDialog(
                                   useSafeArea: false,
                                   context: context,
                                   builder: (_)=> GestureDetector(
                                       onVerticalDragUpdate: (dragUpdateDetails) {
                                         Navigator.of(context).pop();
                                       },
                                       child: Image.network(widget._product.url)
                                   )
                               );
                             },

                           )

                        ),
                      ),
                    ],
              )),
              Expanded( flex:7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget._product.productName,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0)),
                      Text('Stock :'+widget._product.stock.toString(),style:TextStyle(fontSize: 18.0)),
                      Text('Precio :'+widget._product.preciounit.toString(),style:TextStyle(fontSize: 18.0)),
                    ],
                  )),
            ]
          ),
          Row(
              children:[
                Expanded( flex:3,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(icon: Icon(Icons.remove_circle_outline,size: 25.0,), onPressed: (){
                            if(widget._product.cantidad>1){
                              setState(() {widget._product.cantidad--;});
                            }
                        }),
                        Container(width: 20,

                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: new InputDecoration(
                              isDense: true,                      // Added this
                              contentPadding: EdgeInsets.all(0.0),  // Added this//fillColor: Colors.green
                            ),
                            style: TextStyle(fontSize: 16.0),
                              keyboardType: TextInputType.number, onChanged: (input){
                            setState(() {
                              widget._product.cantidad=int.parse(input);
                            });
                          }, controller: TextEditingController()..text = widget._product.cantidad.toString()
                          ),
                        ),
                        IconButton(icon: Icon(Icons.add_circle_outline,size: 25.0,), onPressed: (){
                          setState(() {
                            widget._product.cantidad++;
                          });
                        }),
                      ],
                    )),

                Expanded( flex:7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(

                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: venta.isAdded(widget._product) ? Colors.red: Colors.black)
                        ),
                        onPressed: () {
                          if(venta.isAdded(widget._product)){
                            venta.remove(widget._product);
                          }else{
                            venta.add(widget._product);
                          }

                        },
                        padding: EdgeInsets.all(5.0),
                        color: Colors.white,
                        child: Text(venta.isAdded(widget._product) ? 'QUITAR' : 'AGREGAR',style: TextStyle(color: venta.isAdded(widget._product) ? Colors.red: Colors.black),),
                      ),
                    )),
              ]
          ),
        ]
      ),
    );

  }
}
