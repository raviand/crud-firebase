
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:http/http.dart' as http;
import 'package:form_validation/src/models/producto_model.dart';

class ProductosProvider{

  final String uri = 'https://fotoestudioedu.firebaseio.com';

  Future<bool>crearProducto( ProductoModel producto ) async{

    final url = '$uri/productos.json';

    final response = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;

  }

  Future<List<ProductoModel>> cargarProducto() async {

    final url = '$uri/productos.json';

    final resp = await http.get(url);

    final Map<String, dynamic> decodeData = json.decode(resp.body);

    final List<ProductoModel>  productos = new List();
    
    if(decodeData == null) return [];

    decodeData.forEach((id, prod){
      print(id);
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);
    });

    return productos;

  }

  Future<int>borrarProducto( String id ) async{

    final url = '$uri/productos/$id.json';

    final response = await http.delete(url);

    final decodedData = json.decode(response.body);

    print(decodedData);

    return 1;

  }

  Future<bool> modificarProducto( ProductoModel producto ) async{

    final url = '$uri/productos/${ producto.id }.json';

    final response = await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;

  }

  Future<String> subirImagen(File imagen) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dfu2enauy/image/upload?upload_preset=n4udqhm3');

    final mineType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath('file', imagen.path, contentType: MediaType( mineType[0], mineType[1] ));

    imageUploadRequest.files.add(file);
    
    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final responseData = json.decode(resp.body);

    return responseData['secure_url'];
  }



}