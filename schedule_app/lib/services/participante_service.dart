import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as Http;
import 'package:schedule_app/models/participante.dart';
import 'package:schedule_app/models/response.dart';
import 'package:schedule_app/services/api_service.dart';

class ParticipanteService extends ApiService {
  ParticipanteService() : super("participante");

  Response<List<Participante>> _convertList(Http.Response res) {
    Map<String, dynamic> map = json.decode(res.body);
    Response<List<Participante>> response = Response.fromJson(map);
    List<dynamic> lista = map['data'];
    response.data = lista.map((e) => Participante.fromJson(e)).toList();
    return response;
  }

  Future<Response<Participante>> cadastrar(Participante obj) async {
    Http.Response res = await post(url, obj.toJson());
    if (res.statusCode == 200) {
      return _convertObj(res);
    } else {
      return send(res);
    }
  }

  Future<Response<Participante>> alterar(Participante obj) async {
    Http.Response res = await put(url, obj.toJson());
    if (res.statusCode == 200) {
      return _convertObj(res);
    } else {
      return send(res);
    }
  }

  Response<Participante> _convertObj(Http.Response res) {
    Map<String, dynamic> map = json.decode(res.body);
    Response<Participante> response = Response.fromJson(map);
    response.data = Participante.fromJson(map['data']);
    return response;
  }

  Future<Response<Participante>> buscarPorId(int id) async {
    String api = "$url/$id";
    Http.Response res = await request(api);
    if (res.statusCode == 200) {
      return _convertObj(res);
    }
    return null;
  }

  Future<Response<List<Participante>>> pesquisa(String value, int idUsuario) async {
    String api = "$url?nome=$value&idUsuario=$idUsuario";
    Http.Response res = await request(api);
    if (res.statusCode == 200) {
      return _convertList(res);
    }
    return null;
  }
}
