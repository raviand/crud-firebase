
import 'dart:convert';

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



}