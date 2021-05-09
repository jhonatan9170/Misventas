import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:azblob/azblob.dart';


class AddProductProv with ChangeNotifier {
  PickedFile image ;
  String nombre = "";
  String descripcion = "";
  String marca = "";
  String modelo = "";
  int Stock = 0;
  int StockMinimo = 0;
  int barCode = 0;
  double precioVenta = 0.0;
  double precioCosto = 0.0;
  String urlProduct = "";
  String Usuario = "JCHAVEZ";


  Future sendData() async {
    uploadImageToAzure().then((value) async{
      var url = Uri.parse('https://misventas.azurewebsites.net/api/productList');

      var body = {
        "nombre": nombre,
        "descripcion": descripcion,
        "marca": marca,
        "modelo": modelo,
        "stock": Stock,
        "stockMinimo": StockMinimo,
        "barCode": barCode,
        "precioCosto": precioCosto,
        "precioVenta": precioVenta,
        "urlImage": urlProduct,
        "usuario": Usuario
      };
      print(body);
      Map<String, String> headers = {"Content-type": "application/json"};
      var response = await http.post(
          url, headers: headers, body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');



    });

  }


  Future uploadImageToAzure() async {
    if(image!=null){
      try{
        String fileName = await basename(image.path);
        // read file as Uint8List
        Uint8List content =  await  image.readAsBytes();

        var storage = AzureStorage.parse('DefaultEndpointsProtocol=https;AccountName=misventas;AccountKey=hegEAAq0avkfEJOZbLTdpbk+Quz6XxNJiJfwU80Kjmz/BYjJWC9spOXaKJufmKextj6weM3omXhZwJni/siC2w==;EndpointSuffix=core.windows.net');
        String container="img-misventas";
        String pathImage = '/$container/$fileName';
        // get the mine type of the file
        String contentType= lookupMimeType(fileName);
        await storage.putBlob(pathImage,bodyBytes: content,contentType: contentType,type: BlobType.BlockBlob);
        print("done");
        urlProduct="https://misventas.blob.core.windows.net"+pathImage;
      } on AzureStorageException catch(ex){
        print(ex.message);
      }catch(err){
        print(err);
      }

    }

  }

}