import 'package:enum_to_string/enum_to_string.dart';
import 'package:schedule_app/enumators/agemdanto-status.dart';
import 'package:schedule_app/models/participante.dart';

class Agendamento {
  int id;
  int usuarioId;
  String titulo;
  String observacao;
  dynamic dataHora;
  dynamic dataHoraInicio;
  dynamic dataHoraFim;
  bool realizado;
  AgendamentoStatus situacao;
  List<Participante> participantes;
  int nota;
  String feedback;

  Agendamento();

  Agendamento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuarioId = json['usuarioId'];
    titulo = json['titulo'];
    observacao = json['observacao'];
    dataHora = json['dataHora'];
    dataHoraInicio = json['dataHoraInicio'];
    dataHoraFim = json['dataHoraFim'];
    realizado = json['realizado'];
    situacao = EnumToString.fromString(AgendamentoStatus.values, json['situacao']);
    participantes = List();
    json['participantes'].forEach((e) {
      participantes.add(Participante.fromJson(e['participante']));
    });
    nota = json['nota'];
    ;
    feedback = json['feedback'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data['id'] = id;
    data['usuarioId'] = usuarioId;
    data['titulo'] = titulo;
    data['observacao'] = observacao;
    data['dataHora'] = dataHora;
    data['dataHoraInicio'] = dataHoraInicio;
    data['dataHoraFim'] = dataHoraFim;
    data['relizado'] = realizado;
    if (situacao != null) {
      data['situacao'] = situacao.toString();
    }
    data['participantes'] = [];

    participantes.forEach((element) {
      data['participantes'].add(AgedamentoParticipante(participante: element).toJson());
    });

    data['nota'] = nota;
    data['feedback'] = feedback;
    return data;
  }
}

class AgedamentoParticipante {
  Null id;
  Null agendamento;
  Participante participante;

  AgedamentoParticipante({this.id, this.agendamento, this.participante});

  AgedamentoParticipante.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agendamento = json['agendamento'];
    participante = json['participante'] != null ? new Participante.fromJson(json['participante']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['agendamento'] = this.agendamento;
    if (this.participante != null) {
      data['participante'] = this.participante.toJson();
    }
    return data;
  }
}
