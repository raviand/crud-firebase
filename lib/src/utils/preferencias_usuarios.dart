
import 'package:shared_preferences/shared_preferences.dart';
///
///Esta Clase se encarga de gestionar los datos que se deben almacenar en el dispositivo
///Solo datos estrictamente necesarios para el funcionamiento de la aplicacion
///
class PreferenciasUsuarios{

  /**
   * Para tener esta propiedad disponible se debe realizar las siguientes acciones:
   * 
   * importar en pubspect.yaml => shared_preferences:
   * Se debe inicializar en el 
   * main async {
   * final prefs = PreferenciasUsuarios();
   * await prefs.initPrefs();
   * } 
   */

  static final PreferenciasUsuarios _instance = PreferenciasUsuarios._internal();

  factory PreferenciasUsuarios(){
    return _instance;
  }

  PreferenciasUsuarios._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get genero => _prefs.getInt('genero') ?? 1;
  

  set genero(int value) => _prefs.setInt('genero', value);
  

  get color => _prefs.getBool('color') ?? false;
  

  set color(bool color) => _prefs.setBool('color', color);
  

  get token => _prefs.getString('token') ?? '';

  set token (String token) => _prefs.setString('token', token);

  get lastPage => _prefs.getString('page') ?? 'login';

  set lastPage (String nombre) => _prefs.setString('page', nombre);

}


