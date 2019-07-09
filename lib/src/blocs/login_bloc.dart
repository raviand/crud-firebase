import 'dart:async';

import 'package:form_validation/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Metodos para escuchar los cambios
  Stream<String> get emailStream => _emailController.stream.transform( validarEmail );
  Stream<String> get passwordStream => _passwordController.stream.transform( validarPassword );
  Stream<bool> get formValidStream => Observable.combineLatest2(emailStream, passwordStream, (e, a) => true);
  //Metodos para insertar cambios
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Obtener el dato de los Streams
  String get email      => _emailController.value;
  String get password   => _passwordController.value;

  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }
  

}