import 'dart:io';

import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/providers/prouctos_provider.dart';
import 'package:rxdart/subjects.dart';

class ProductosBloc {

  final _productosController = BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = BehaviorSubject<bool>();

  final _productosProvider = ProductosProvider();

  Stream<List<ProductoModel>> get productosStream => _productosController.stream;
  Stream<bool> get cargando => _cargandoController.stream;
  
  void cargarProductos() async {
    final productos = await _productosProvider.cargarProducto();
    _productosController.sink.add(productos);
  }

  void agregarProducto( ProductoModel producto ) async {
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(producto);
    _cargandoController.sink.add(false);
  }

  Future<String> subirFoto( File foto ) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productosProvider.subirImagen(foto);
    _cargandoController.sink.add(false);
    return fotoUrl;
  }

  void editarProducto( ProductoModel producto ) async {
    _cargandoController.sink.add(true);
    await _productosProvider.modificarProducto(producto);
    _cargandoController.sink.add(false);
  }

  void eliminarProducto( String id ) async {
    await _productosProvider.borrarProducto(id);
  }



  dispose(){
    _productosController?.close();
  _cargandoController?.close(); 
  }




}