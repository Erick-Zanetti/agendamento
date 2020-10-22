import 'package:flutter/material.dart';
import 'package:schedule_app/enumators/agemdanto-status.dart';
import 'package:schedule_app/models/agendamento.dart';
import 'package:schedule_app/screens/cadastro_agendamento_page.dart';
import 'package:schedule_app/utils/loading_util.dart';

class AgendamentoScreen extends StatefulWidget {
  @override
  _AgendamentoScreenState createState() => _AgendamentoScreenState();

  Agendamento agendamento;

  AgendamentoScreen({this.agendamento}): super();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {

  @override
  void initState() {
    super.initState();
  }

  void iniciarReuniao() {
    var load = LoadingUtil.createLoading(context, "Iniciando atendimento...");
    load.show();
  }

  String _getSituacao() {
    switch(widget.agendamento.situacao) {
      case AgendamentoStatus.AGENDADO: return "Agendado";
      case AgendamentoStatus.CANCELADO: return "Cancelada";
      case AgendamentoStatus.CONCLUIDO: return "Finalizada";
      case AgendamentoStatus.INICIADO: return "Em andamento";
      case AgendamentoStatus.REAGENDADO: return "Reagendada";
    }
    return "";
  }

  editar() async {
    var obj = await Navigator.push(context, MaterialPageRoute(
      builder: (ctx) => CadastroAgendamentoPage(id: widget.agendamento.id,)
    ));
    if(obj != null) {
      setState(() {
        widget.agendamento = obj;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.agendamento.titulo),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: editar,
          )
        ],
      ),     
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(widget.agendamento.observacao, style: TextStyle(color: Colors.white),),
                  color: Colors.blue[800],
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Titulo: ${widget.agendamento.titulo}"),
                      SizedBox(height: 8.0,),
                      Text("Data do reunião: ${widget.agendamento.dataHora}"),
                      SizedBox(height: 8.0,),
                      Text("Situação: ${_getSituacao()}")
                    ],
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      getButtonStatus()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getButtonStatus() {
    return RaisedButton(
      child: Text("Iniciar reunião", style: TextStyle(color: Colors.white),),
      onPressed: iniciarReuniao,
      color: Theme.of(context).accentColor,
    );
  }
}