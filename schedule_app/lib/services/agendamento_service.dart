import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:schedule_app/models/agendamento.dart';
import 'package:schedule_app/models/response.dart';
import 'package:schedule_app/services/api_service.dart';
import 'package:schedule_app/services/usuario_service.dart';

class AgendamentoService extends ApiService {
  final usuario = UsuarioService();

  AgendamentoService() : super("agendamento");

  Future<Response<List<Agendamento>>> meusAgendamentos() async {
    var user = await usuario.getLogado();
    String api = "$url/por-usuario/${user.id}";
    Http.Response res = await request(api);
    if (res.statusCode == 200) {
      return _convertList(res);
    }
    return null;
  }

  Response<List<Agendamento>> _convertList(Http.Response res) {
    Map<String, dynamic> map = json.decode(res.body);
    Response<List<Agendamento>> response = Response.fromJson(map);
    List<dynamic> lista = map['data'];
    response.data = lista.map((e) => Agendamento.fromJson(e)).toList();
    return response;
  }

  Future<Response<Agendamento>> cadastrar(Agendamento obj) async {
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

  Future<Response<Agendamento>> buscarPorId(int id) async {
    String api = "$url/$id";
    Http.Response res = await request(api);
    if (res.statusCode == 200) {
      return _convertObj(res);
    } else {
      return send(res);
    }
  }

  Future<Response<Agendamento>> alterar(Agendamento obj) async {
    Http.Response res = await put(url, obj.toJson());
    if (res.statusCode == 200) {
      return _convertObj(res);
    } else {
      return send(res);
    }
  }

  Response<Agendamento> _convertObj(Http.Response res) {
    Map<String, dynamic> map = json.decode(res.body);
    Response<Agendamento> response = Response.fromJson(map);
    response.data = Agendamento.fromJson(map['data']);
    return response;
  }
}
