import 'package:flutter/material.dart';

import 'package:form_validation/src/blocs/login_bloc.dart';
import 'package:form_validation/src/blocs/productos_bloc.dart';

export 'package:form_validation/src/blocs/login_bloc.dart';
export 'package:form_validation/src/blocs/productos_bloc.dart';

class Provider extends InheritedWidget {

  final loginBloc = LoginBloc();
  final _productosBloc = ProductosBloc();

  static Provider _instancia;

  
  Provider._internal( {Key key, Widget child} ) : super(key: key, child:child);

  factory Provider( {Key key, Widget child} ){
    if(_instancia == null){
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context) {
    return ( context.inheritFromWidgetOfExactType(Provider) as Provider).loginBloc;
  }

  static ProductosBloc productosBloc (BuildContext context) {
    return ( context.inheritFromWidgetOfExactType(Provider) as Provider)._productosBloc;
  }

}