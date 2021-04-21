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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded( flex: 2,
                child: Image.network(_product.url)),
            Expanded(
            flex: 7,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                    Text(_product.productName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
                    Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                      Text("P. unit :s/ "+_product.preciounit.toString(),),

                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: (){
                          venta.reduceCantidad(_product);
                        }),
                        Container(width: 20,
                          child: TextField(
                              onChanged: (input){
                                venta.updateCantidad(_product, int.parse(input));
                              },
                            keyboardType: TextInputType.number,  controller: TextEditingController()..text = venta.getCantidad(_product).toString()),),
                        IconButton(icon: Icon(Icons.add_circle_outline), onPressed: (){
                          venta.addCantidad(_product);
                        }),
                        Text("S/",style: TextStyle(fontSize: 16.0)),
                        Container(width: 50,
                          child: TextField(onChanged: (input){
                            _product.preciofinal=double.parse(input);
                          },
                              keyboardType: TextInputType.number,  controller: TextEditingController()..text = (_product.preciofinal).toString()),

                        ),
                        Text("S/"+(_product.cantidad*_product.preciofinal).toString(),style: TextStyle(fontSize: 16.0),)
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
