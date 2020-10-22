import 'package:flutter/material.dart';
import 'package:schedule_app/models/participante.dart';
import 'package:schedule_app/models/usuario.dart';
import 'package:schedule_app/services/participante_service.dart';
import 'package:schedule_app/services/usuario_service.dart';
import 'package:schedule_app/utils/dialog.dart';
import 'package:schedule_app/utils/loading_util.dart';

class CadastroParticipanteScreen extends StatefulWidget {
  @override
  _CadastroParticipanteScreenState createState() => _CadastroParticipanteScreenState();

  int id;

  CadastroParticipanteScreen({this.id}) : super();
}

class _CadastroParticipanteScreenState extends State<CadastroParticipanteScreen> {
  final _formKey = GlobalKey<FormState>();

  final service = ParticipanteService();

  TextEditingController nomeCtrl = new TextEditingController();
  TextEditingController emailCtrl = new TextEditingController();
  TextEditingController telCtrl = new TextEditingController();

  bool ativo = true;
  bool notifica = true;

  Participante obj = new Participante();

  final usuarioService = UsuarioService();

  Usuario usuario;

  @override
  void initState() {
    super.initState();
    buscarUsuario().then((value) {
      if (widget.id != null) {
        buscar();
      }
    });
  }

  Future<void> buscarUsuario() async {
    Usuario a = await usuarioService.getLogado();
    setState(() {
      usuario = a;
    });
  }

  buscar() {
    var load = LoadingUtil.createLoading(context, "Buscando registro...");
    load.show().then((value) {
      service.buscarPorId(widget.id).then((value) {
        load.hide();
        obj = value.data;
        montarForm();
      }).catchError((error) {
        load.hide();
        DialogUtil.showError(error, context).then((value) => load.hide());
      });
    });
  }

  montarForm() {
    setState(() {
      ativo = obj.ativo;
      notifica = obj.notifica;
      nomeCtrl.text = obj.nome;
      emailCtrl.text = obj.email;
      telCtrl.text = obj.telefone;
    });
  }

  salvar() {
    if (_formKey.currentState.validate()) {
      obj.nome = nomeCtrl.value.text;
      obj.email = emailCtrl.value.text;
      obj.telefone = telCtrl.value.text;

      obj.ativo = ativo;
      obj.notifica = notifica;

      obj.usuario = usuario;

      var load = LoadingUtil.createLoading(context, "cadastrando...");
      load.show();

      if (obj.id != null) {
        service.alterar(obj).then((value) {
          load.hide();
          DialogUtil.showResponse(context: context, response: value, message: "Participante alterado com sucesso.").then((value) => voltar());
        }).catchError((error) {
          load.hide();
          DialogUtil.showError(error, context).then((value) => load.hide());
        });
      } else {
        service.cadastrar(obj).then((value) {
          load.hide();
          DialogUtil.showResponse(context: context, response: value, message: "Participante cadastrado.").then((value) => voltar());
        }).catchError((error) {
          load.hide();
          DialogUtil.showError(error, context).then((value) => load.hide());
        });
      }
    }
  }

  changeAtivo(bool val) {
    setState(() {
      obj.ativo = val;
    });
  }

  changeNotifica(bool val) {
    setState(() {
      obj.notifica = val;
    });
  }

  voltar() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Participante"),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                      controller: nomeCtrl,
                      decoration: InputDecoration(labelText: "Nome"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Campo obrigatório";
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                      controller: emailCtrl,
                      decoration: InputDecoration(labelText: "E-mail"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Campo obrigatório";
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: telCtrl,
                    decoration: InputDecoration(labelText: "Telefone"),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: obj.ativo,
                        onChanged: changeAtivo,
                      ),
                      Text("Ativo")
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: obj.notifica,
                        onChanged: changeNotifica,
                      ),
                      Text("Notificar")
                    ],
                  )
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
