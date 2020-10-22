import 'package:schedule_app/models/usuario.dart';

class Participante {
  int id;
  String nome;
  String email;
  String telefone;
  Usuario usuario;
  bool notifica = true;
  bool ativo = true;

  Participante();

  Participante.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    usuario = Usuario.fromJson(json['usuario']);
    telefone = json['telefone'];
    notifica = json['notifica'];
    ativo = json['ativo'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['id'] = id;
    json['nome'] = nome;
    json['email'] = email;
    json['usuario'] = usuario;
    json['telefone'] = telefone;
    json['notifica'] = notifica;
    json['ativo'] = ativo;
    return json;
  }
}
