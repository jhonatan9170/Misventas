import 'dart:ui';
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
    return Container(
      margin: EdgeInsets.all(5.0),
      width: 180.0,
        height: 250,
        constraints: BoxConstraints(
            minHeight: 200, maxHeight: 400),
      padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(15.0)
        ),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child:Image.network(widget._product.url)),
          Text(widget._product.productName,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Stock :'),Text('${widget._product.stock}')]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Precio :'),Text('${widget._product.preciounit}')]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: (){
                if(widget._product.cantidad>1){
                  setState(() {widget._product.cantidad--;});
                }
              }),
              Container(width: 20.0,  child: TextField(
                  keyboardType: TextInputType.number, onChanged: (input){
                    setState(() {
                      widget._product.cantidad=int.parse(input);
                    });
              }, controller: TextEditingController()..text = widget._product.cantidad.toString() )),
              IconButton(icon: Icon(Icons.add_circle_outline), onPressed: (){
                setState(() {
                  widget._product.cantidad++;
                });


              }),
            ],
          ),
          SizedBox(child: ElevatedButton(
            onPressed: (){
              if(venta.isAdded(widget._product)){
                venta.remove(widget._product);
              }else{
                venta.add(widget._product);
              }
            },

            child: Text(venta.isAdded(widget._product) ? 'Quitar' : 'Agregar'),
          style: TextButton.styleFrom(backgroundColor: venta.isAdded(widget._product) ? Colors.red : Colors.blue,)
          ),
            height: 30.0,
          )
        ],)
    );
  }
}
