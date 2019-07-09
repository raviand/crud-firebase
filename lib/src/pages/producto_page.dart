import 'package:flutter/material.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/providers/prouctos_provider.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final productoProvider = new ProductosProvider();


  ProductoModel producto = ProductoModel();
  @override
  Widget build(BuildContext context) {
    
    final ProductoModel prodEdit = ModalRoute.of(context).settings.arguments;
    if(prodEdit != null){
      producto = prodEdit;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
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
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
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

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: _submit,
    );
  }

  void _submit(){

    
    if(!formKey.currentState.validate()) return ;

    formKey.currentState.save();
    print('Todo Ok');
    print('producto titulo ${producto.titulo}');
    print('producto valor ${producto.valor}');
    print('producto disponible ${producto.disponible}');

    if(producto.id == null){
      productoProvider.crearProducto(producto);

    }else{
      productoProvider.modificarProducto(producto);
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
}
