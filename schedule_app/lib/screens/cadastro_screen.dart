import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:schedule_app/models/response.dart';
import 'package:schedule_app/models/usuario.dart';
import 'package:schedule_app/services/usuario_service.dart';
import 'package:schedule_app/utils/dialog.dart';
import 'package:schedule_app/utils/loading_util.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final service = UsuarioService();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final double spaceFields = 8.0;

  _cadastrar() {
    if (_fbKey.currentState.validate()) {
      Usuario usuario = Usuario();

      usuario.nome = _fbKey.currentState.fields['nome'].currentState.value;
      usuario.email = _fbKey.currentState.fields['email'].currentState.value;
      usuario.senha = _fbKey.currentState.fields['senha'].currentState.value;
      String confirmeSenha = _fbKey.currentState.fields['confirmeSenha'].currentState.value;

      if (usuario.senha != confirmeSenha) {
        DialogUtil.showError(Response.messageError("As senhas não conferem."), context);
        return;
      }

      var load = LoadingUtil.createLoading(context, "Cadastrando...");
      load.show();
      service.cadastrar(usuario).then((value) {
        load.hide();
        DialogUtil.showResponse(context: context, response: value, message: "usuário cadastrado.").then((value) => _abrirLogin());
      }).catchError((error) {
        load.hide();
        DialogUtil.showError(error, context).then((value) => load.hide());
      });
    }
  }

  _abrirLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 24, right: 24),
          height: MediaQuery.of(context).size.height < 600.0 ? 600.0 : MediaQuery.of(context).size.height,
          child: FormBuilder(
            key: _fbKey,
            // autovalidate: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 48, bottom: 12),
                        child: Center(
                          child: Text("Cadastro", style: TextStyle(fontSize: 32)),
                        ),
                      ),
                      FormBuilderTextField(
                        attribute: "nome",
                        maxLength: 50,
                        maxLines: 1,
                        decoration: InputDecoration(labelText: "Nome"),
                        validators: [
                          FormBuilderValidators.minLength(3, errorText: "Nome deve conter no mínimo 3 caracteres."),
                          FormBuilderValidators.required(errorText: "Campo obrigatório")
                        ],
                      ),
                      SizedBox(
                        height: spaceFields,
                      ),
                      FormBuilderTextField(
                        attribute: "email",
                        maxLength: 100,
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: "E-mail"),
                        validators: [
                          FormBuilderValidators.required(errorText: "Campo obrigatório"),
                          FormBuilderValidators.email(errorText: "E-mail inválido.")
                        ],
                      ),
                      SizedBox(
                        height: spaceFields,
                      ),
                      FormBuilderTextField(
                        attribute: "senha",
                        maxLength: 100,
                        maxLines: 1,
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Senha"),
                        validators: [
                          FormBuilderValidators.required(errorText: "Campo obrigatório"),
                        ],
                      ),
                      SizedBox(
                        height: spaceFields,
                      ),
                      FormBuilderTextField(
                        attribute: "confirmeSenha",
                        maxLength: 100,
                        maxLines: 1,
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Confirme sua senha"),
                        validators: [
                          FormBuilderValidators.required(errorText: "Campo obrigatório"),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  onPressed: _cadastrar,
                  child: Text("Cadastrar", style: TextStyle(fontSize: 18, color: Colors.white)),
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                ),
                SizedBox(height: 16),
                FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32), side: BorderSide(color: Theme.of(context).primaryColor)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Voltar", style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor)),
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
