import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mis_ventas/provider/AddProducProv.dart';
import 'package:provider/provider.dart';




class productImage extends StatefulWidget{

  @override
  _productImageState createState() => _productImageState();
}

class _productImageState extends State<productImage> {
  final imagePicker = ImagePicker();

  PickedFile image;

  @override
  Widget build(BuildContext context) {

    final addProduct = Provider.of<AddProductProv>(context);
    void _openCamera() async {
      PickedFile picture = await imagePicker.getImage(
        source: ImageSource.camera,
      );
      Navigator.pop(context);
      setState(() {
        image= (picture);
      });
      addProduct.image=image;
    }
    void _openGallery() async {
      PickedFile picture = await imagePicker.getImage(
        source: ImageSource.gallery,
      );
      setState(() {
        image=(picture);
      });
      Navigator.pop(context);
      addProduct.image=image;
    }

    Future<void> _optionsDialogBox() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text('Cámara'),
                      onTap: _openCamera,

                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    GestureDetector(
                      child: Text('Galería'),
                      onTap: _openGallery,

                    ),
                  ],
                ),
              ),
            );
          });
    }
    return
      Container(
          padding: EdgeInsets.all(10.0),
          height: MediaQuery
              .of(context)
              .size
              .width * 0.7,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Stack(children: [
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: image != null ? GestureDetector(
               onTap: (){
                 showDialog(
                   useSafeArea: false,
                   context: context,
                   builder: (_)=> GestureDetector(
                       onVerticalDragUpdate: (dragUpdateDetails) {
                         Navigator.of(context).pop();
                       },
                       child: Image.file(File(image.path))
                   )
                 );
               },
                child: Image.file(
                    File(image.path), fit: BoxFit.cover,),
              )
                  : Center(child: Text("INSERTE IMAGEN")),),
            Container(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(onPressed: () {
                _optionsDialogBox();
              }, child: Icon(Icons.camera_alt),),
            )
          ])

      );

  }
}


