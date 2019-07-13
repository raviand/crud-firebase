import 'dart:convert';

import 'package:form_validation/src/utils/preferencias_usuarios.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider{

  final String _firebaseToken = 'AIzaSyBesL-EeEtNlohrxjjyGuiFSg8lGXsH3Qo';
  final _prefs = PreferenciasUsuarios();

  Future<Map<String, dynamic>> nuevoUsuario(String email, String password) async {

    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken' : true
    };

    final respuesta = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=$_firebaseToken',
      body: json.encode( authData )
    );

    Map<String, dynamic> decodeRespuesta = json.decode( respuesta.body );

    print(decodeRespuesta);

    if(decodeRespuesta.containsKey('idToken')){
      _prefs.token = decodeRespuesta['idToken'];
      return { 'ok': true, 'token': decodeRespuesta['idToken'] };
    }else{

      return { 'ok': false, 'message': getErrorMessage(decodeRespuesta['error']['message'])  };
    }


  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken' : true
    };

    final respuesta = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$_firebaseToken',
      body: json.encode( authData )
    );

    Map<String, dynamic> decodeRespuesta = json.decode( respuesta.body );

    print(decodeRespuesta);

    if(decodeRespuesta.containsKey('idToken')){
      _prefs.token = decodeRespuesta['idToken'];
      return { 'ok': true, 'token': decodeRespuesta['idToken'] };
    }else{     
      return { 'ok': false, 'message': getErrorMessage(decodeRespuesta['error']['message']) };
    }

    

  }

  String getErrorMessage(String messageResponse){
      String message = '';
      switch (messageResponse) {
        case 'MISSING_EMAIL':
          message = 'Debe ingresar un Email';
          break;
        case 'EMAIL_NOT_FOUND':
          message = 'El mail ingresado no se encuentra registrado';
          break;
        case 'INVALID_PASSWORD':
          message = 'La contraseña es invalida';
          break;
        case 'EMAIL_EXISTS':
          message = 'El email ya esta registrado';
          break;
        case 'USER_DISABLED':
          message = 'La cuenta ha sido deshabilitada';
          break;//TOO_MANY_ATTEMPTS_TRY_LATER
        case 'TOO_MANY_ATTEMPTS_TRY_LATER':
          message = 'Demasiados intentos, reintente mas tarde';
          break;
        case 'OPERATION_NOT_ALLOWED':
          message = 'Operacion no permitida';
          break;
        case 'ADMIN_ONLY_OPERATION':
          message = 'Operacion solo permitida para el administrador';
          break;
        default:
          message = messageResponse;
      }

      return message;
    }


}