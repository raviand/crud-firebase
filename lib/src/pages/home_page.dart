import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/provider.dart';

import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/providers/prouctos_provider.dart';

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page') 
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
      
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto'),
    );
  }

  Widget _crearListado(ProductosBloc bloc){

    return StreamBuilder(
      stream: bloc.productosStream ,

      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        if(snapshot.hasData){
          final productos =snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i)=> _crearItem(context, productos[i], bloc),
          );
        }else{
          return Center( child: CircularProgressIndicator(),);
        }
      },
    );


 
  }

  Widget _crearItem(BuildContext context, ProductoModel producto, ProductosBloc bloc){
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.redAccent,
      ),
      onDismissed: ( direction ) => bloc.eliminarProducto(producto.id),
      child: Card(
        child: Column(
          children: <Widget>[
            
            (producto.fotoUrl == null) 
              ? Image(image: AssetImage('assets/img/no-image.png'),) 
              : FadeInImage(
                image: NetworkImage(producto.fotoUrl),
                placeholder: AssetImage('assets/img/jar-loading.gif'),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ListTile(
              title: Text('${ producto.titulo } - ${ producto.valor }'),
              subtitle: Text(producto.id),
              onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
            ),
          ],
        ),
      )
    );
  }
}

