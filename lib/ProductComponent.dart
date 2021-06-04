import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mis_ventas/Models/Product.dart';
import 'package:mis_ventas/provider/Ventasprov.dart';
import 'package:provider/provider.dart';

class ProductComponent extends StatelessWidget {
  Product _product;
  ProductComponent(this._product);
  @override
  Widget build(BuildContext context) {
    final venta = Provider.of<Ventasprov>(context);
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.all(8.0),

      width: MediaQuery.of(context).size.width*0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0)

      ),
      child: Stack(
        children: [
          Container(alignment: Alignment.topRight, child: IconButton(icon: Icon(Icons.remove_circle,color: Colors.red,), onPressed: (){
            venta.remove(_product);
          })),
          Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Image.network(_product.url)),
            Expanded(
            flex: 4,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_product.productName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
                    Row(mainAxisAlignment: MainAxisAlignment.start,children: [
                      Text("P. unit :s/ "+_product.preciounit.toString(),),

                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            Text("S/",style: TextStyle(fontSize: 14.0)),
                            Container(width: 60,
                              child: TextField(
                                textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14.0),
                                  decoration: new InputDecoration(
                                    isDense: true,                      // Added this
                                    contentPadding: EdgeInsets.all(0.0),  // Added this//fillColor: Colors.green
                                  ),
                                  onChanged: (input){
                                _product.preciofinal=double.parse(input);
                              },
                                  keyboardType: TextInputType.number,  controller: TextEditingController()..text = (_product.preciofinal).toString()),

                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(icon: Icon(Icons.remove_circle_outline,size: 18.0,), onPressed: (){
                              venta.reduceCantidad(_product);
                            }),
                            Container(width: 15,

                              child: TextField(
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                    isDense: true,                      // Added this
                                    contentPadding: EdgeInsets.all(0.0),  // Added this//fillColor: Colors.green
                                  ),
                                  style: TextStyle(fontSize: 14.0),
                                  onChanged: (input){
                                    venta.updateCantidad(_product, int.parse(input));
                                  },
                                  keyboardType: TextInputType.number,  controller: TextEditingController()..text = venta.getCantidad(_product).toString()),),
                            IconButton(icon: Icon(Icons.add_circle_outline,size: 18.0,), onPressed: (){
                              venta.addCantidad(_product);
                            }),
                          ],
                        ),

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Subtotal:  ",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("S/"+(_product.cantidad*_product.preciofinal).toString(),style: TextStyle(fontSize: 14.0),),
                      ],
                    )


                  ],
                ),
              ),
            )
          ],
        ),]
      ),
    );
  }
}
