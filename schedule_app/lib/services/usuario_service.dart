import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:schedule_app/models/login.dart';
import 'package:schedule_app/models/response.dart';
import 'package:schedule_app/models/usuario.dart';
import 'package:schedule_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioService extends ApiService {
  UsuarioService() : super("usuario");

  Future<Response<Usuario>> cadastrar(Usuario obj) async {
    try {
      Http.Response res = await post(url, obj.toJson());
      if (res.statusCode == 200) {
        return _convertObj(res);
      } else {
        return send(res);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Response<Usuario>> logar(Login obj) async {
    String api = "$url/login";
    Http.Response res = await post(api, obj.toJson());
    if (res.statusCode == 200) {
      return _convertObj(res);
    } else {
      send(res);
    }
  }

  void saveStorage(Usuario usuario) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = json.encode(usuario.toJson());
    prefs.setString('usuario', str);
  }

  Future<Usuario> getLogado() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("usuario");
    if (data == null) {
      return null;
    }
    return Usuario.fromJson(json.decode(data));
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Response<Usuario> _convertObj(Http.Response res) {
    Map<String, dynamic> map = json.decode(res.body);
    Response<Usuario> response = Response.fromJson(map);
    response.data = Usuario.fromJson(map['data']);
    return response;
  }
}
