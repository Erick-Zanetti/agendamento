import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:schedule_app/models/agendamento.dart';
import 'package:schedule_app/models/participante.dart';
import 'package:schedule_app/models/response.dart';
import 'package:schedule_app/models/usuario.dart';
import 'package:schedule_app/services/agendamento_service.dart';
import 'package:schedule_app/services/usuario_service.dart';
import 'package:schedule_app/utils/dialog.dart';
import 'package:schedule_app/utils/loading_util.dart';
import 'package:schedule_app/widgets/lista_participantes.dart';

class CadastroAgendamentoPage extends StatefulWidget {
  @override
  _CadastroAgendamentoPageState createState() => _CadastroAgendamentoPageState();

  int id;

  CadastroAgendamentoPage({this.id});
}

class _CadastroAgendamentoPageState extends State<CadastroAgendamentoPage> {
  final _formKey = GlobalKey<FormState>();

  final service = AgendamentoService();
  final usuarioService = UsuarioService();

  Usuario usuario;

  TextEditingController tituloCtrl = new TextEditingController();
  TextEditingController observacaoCtrl = new TextEditingController();
  DateTime dia;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final DateFormat formatterCt = DateFormat('dd-MM-yyyy HH:mm:ss');
  TimeOfDay horario;

  String diaStr = "Selecione...";
  String hrrStr = "Selecione...";

  Agendamento agendamento = Agendamento();

  List<Participante> participanteList = List();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      buscar();
    }
  }

  buscar() {
    var load = LoadingUtil.createLoading(context, "Buscando registro...");
    load.show().then((value) {
      service.buscarPorId(widget.id).then((value) {
        load.hide();
        agendamento = value.data;
        montarForm();
      }).catchError((error) {
        load.hide();
        DialogUtil.showError(error, context).then((value) => load.hide());
      });
    });
  }

  montarForm() {
    setState(() {
      tituloCtrl.text = agendamento.titulo;
      observacaoCtrl.text = agendamento.observacao;

      dia = formatterCt.parse(agendamento.dataHora);
      horario = TimeOfDay.fromDateTime(dia);
      diaStr = formatter.format(dia);
      hrrStr = horario.hour.toString() + ':' + horario.minute.toString();

      participanteList = agendamento.participantes;
    });
  }

  salvar() async {
    if (_formKey.currentState.validate()) {
      if (dia == null) {
        DialogUtil.showError(Response.messageError("A data do agendamento não foi informada."), context);
        return;
      }

      if (horario == null) {
        DialogUtil.showError(Response.messageError("O horário do agendamento não foi informado."), context);
        return;
      }

      Usuario user = await usuarioService.getLogado();

      agendamento.titulo = tituloCtrl.value.text;
      agendamento.observacao = observacaoCtrl.value.text;

      agendamento.usuarioId = user.id;

      dia = dia.add(Duration(hours: horario.hour, minutes: horario.minute));

      agendamento.dataHora = formatterCt.format(dia);

      agendamento.participantes = participanteList;
      var load = LoadingUtil.createLoading(context, "Agendando reunião...");
      load.show();

      if (widget.id != null) {
        service.alterar(agendamento).then((value) {
          load.hide();
          DialogUtil.showResponse(context: context, response: value, message: "Agendamento atualizado.").then((value) => voltar(load));
        }).catchError((error) {
          DialogUtil.showError(error, context).then((value) => load.hide());
        });
      } else {
        service.cadastrar(agendamento).then((value) {
          load.hide();
          DialogUtil.showResponse(context: context, response: value, message: "Agendamento cadastrado.").then((value) => voltar(load));
        }).catchError((error) {
          DialogUtil.showError(error, context).then((value) => load.hide());
        });
      }
    }
  }

  voltar(ProgressDialog load) {
    load.hide();
    Navigator.of(context).pop(agendamento);
  }

  selecionarData() async {
    dia = await showDatePicker(
        context: context, initialDate: dia != null ? dia : DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.utc(3000, 12, 31));
    if (dia != null) {
      setState(() {
        diaStr = formatter.format(dia);
      });
    }
  }

  selecionarParticipantes() async {
    List<int> idsParts = List();
    this.participanteList.forEach((element) {
      idsParts.add(element.id);
    });
    this.participanteList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ListaParticipantesWidget(
          search: true,
          selectedList: idsParts,
        ),
      ),
    );
    setState(() {});
  }

  selecionarHorario() async {
    horario = await showTimePicker(context: context, initialTime: horario != null ? horario : TimeOfDay.now());
    if (horario != null) {
      setState(() {
        hrrStr = horario.hour.toString() + ':' + horario.minute.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agendamento"),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: 128.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: tituloCtrl,
                    decoration: InputDecoration(labelText: "Titulo"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: observacaoCtrl,
                    maxLines: 20,
                    minLines: 5,
                    decoration: InputDecoration(labelText: "Observações"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text("Data do agendanto*"),
                            FlatButton(
                              child: Text("$diaStr"),
                              onPressed: selecionarData,
                              color: Colors.grey[200],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text("Horário*"),
                            FlatButton(
                              child: Text("$hrrStr"),
                              onPressed: selecionarHorario,
                              color: Colors.grey[200],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text("Participantes*"),
                            FlatButton(
                              child: Text("Selecione..."),
                              onPressed: selecionarParticipantes,
                              color: Colors.grey[200],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey,
                        ),
                        left: BorderSide(
                          color: Colors.grey,
                        ),
                        right: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        ...this.participanteList.map((participante) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(participante.nome),
                                  subtitle: Text(participante.email),
                                  leading: Icon(Icons.person),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: salvar,
        child: Icon(Icons.check),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
