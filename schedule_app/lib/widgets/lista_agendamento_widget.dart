import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/models/agendamento.dart';
import 'package:schedule_app/models/response.dart';
import 'package:schedule_app/screens/agendamento_screen.dart';
import 'package:schedule_app/services/agendamento_service.dart';

class ListaAgendamento extends StatefulWidget {
  @override
  _ListaAgendamentoState createState() => _ListaAgendamentoState();
}

class _ListaAgendamentoState extends State<ListaAgendamento> {
  final service = AgendamentoService();

  @override
  void initState() {
    super.initState();
    carregarAgendamentos();
  }

  Future<List<Agendamento>> carregarAgendamentos() async {
    Response<List<Agendamento>> res = await service.meusAgendamentos();
    return res.data;
  }

  novo() async {
    await Navigator.pushNamed(context, "/cadastro-agendamento");
    setState(() {});
  }

  abrirAgendamento(Agendamento agendamento) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AgendamentoScreen(agendamento: agendamento)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data[index].titulo),
                    subtitle: Text(snapshot.data[index].dataHora),
                    leading: Icon(Icons.access_time),
                    onTap: () {
                      abrirAgendamento(snapshot.data[index]);
                    },
                  );
                },
              );
            }
            return Text("Ops ocorreu um erro!");
          },
          future: carregarAgendamentos(),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: novo,
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
