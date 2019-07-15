import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/productos_bloc.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  ProductoModel producto = ProductoModel();
  bool _guardando = false;
  File foto;
  @override
  Widget build(BuildContext context) {
  final ProductosBloc productosBloc = Provider.productosBloc(context);
    final ProductoModel prodEdit = ModalRoute.of(context).settings.arguments;
    if(prodEdit != null){
      producto = prodEdit;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Productos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () =>_capturarImagen(ImageSource.gallery),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () =>_capturarImagen(ImageSource.camera),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(productosBloc)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre Producto'
      ),
      onSaved: (value)=> producto.titulo = value,
      validator: (value) {
        if ( value.length < 3){
          return 'Ingrese un nombre correcto';
        }
        return null;
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value)=> producto.valor = double.parse(value) ,
      validator: (value) {
        if ( utils.isNumeric(value)){
          return null;
        }
        return 'El valor ingresado no corresponde a un numero';
      },
      
    );
  }

  Widget _crearBoton(ProductosBloc productosBloc ) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: ( _guardando ) ? null : () => _submit(productosBloc),
    );
  }

  void _submit(ProductosBloc productosBloc )async {

    
    if(!formKey.currentState.validate()) return ;

    formKey.currentState.save();
    
    setState(() => _guardando = true);

    if( foto != null){
      producto.fotoUrl = await productosBloc.subirFoto(foto);
    }

    if(producto.id == null){
      productosBloc.agregarProducto(producto);
      mostrarSnackbar('Se ha creado un nuevo registro');
    }else{
      productosBloc.editarProducto(producto);
      mostrarSnackbar('El articulo se modifico correctamnte');
    }

    Navigator.of(context).pop();


  }

  void mostrarSnackbar(String mensaje){
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    if(scaffoldKey.currentState != null ){
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState( () => producto.disponible = value ),
    );
  }

  _mostrarFoto(){

    if( producto.fotoUrl != null ){
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/img/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }else{
      return Image(
        image:  AssetImage( foto?.path ?? 'assets/img/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }

  }

  _capturarImagen(ImageSource origen) async {
    foto = await ImagePicker.pickImage(
      source: origen,
    );

    if(foto != null){
      producto.fotoUrl = null;
    }

    setState(() {
      
    });
  }

  
}
