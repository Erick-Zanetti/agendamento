import 'package:flutter/material.dart';
import 'package:schedule_app/models/login.dart';
import 'package:schedule_app/models/response.dart';
import 'package:schedule_app/models/usuario.dart';
import 'package:schedule_app/services/usuario_service.dart';
import 'package:schedule_app/utils/dialog.dart';
import 'package:schedule_app/utils/loading_util.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController loginCtrl = new TextEditingController();
  TextEditingController senhaCtrl = new TextEditingController();

  final service = UsuarioService();

  _cadastrar() {
    Navigator.pushNamed(context, '/cadastro');
  }

  _logar() {
    if (_formKey.currentState.validate()) {
      Login login = Login();
      login.login = loginCtrl.text.toString();
      login.senha = senhaCtrl.text.toString();

      var load = LoadingUtil.createLoading(context, "Entrando...");
      load.show();
      service.logar(login).then((value) {
        load.hide();
        _abrirHome(value);
      }).catchError((error) {
        load.hide();
        DialogUtil.showError(error, context).then((value) => load.hide());
      });
    }
  }

  _abrirHome(Response<Usuario> response) {
    service.saveStorage(response.data);
    Navigator.popAndPushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            color: Colors.white,
            padding: EdgeInsets.only(right: 24, left: 24),
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text("Login", style: TextStyle(
                          fontSize: 48,
                          color: Theme.of(context).primaryColor
                      )),
                    ),
                  ),
                  Expanded(
                      flex: 6,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Informe seu e-mail",
                                  labelText: "E-mail"
                              ),
                              controller: loginCtrl,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Campo obrigatório";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "Informe sua senha",
                                  labelText: "Senha"
                              ),
                              controller: senhaCtrl,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Campo obrigatório";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)),
                              onPressed: _logar,
                              child: Text("Entrar", style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white
                              )),
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                            ),
                            SizedBox(height: 24),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  side: BorderSide(
                                      color: Theme
                                          .of(context)
                                          .primaryColor
                                  )
                              ),
                              onPressed: _cadastrar,
                              child: Text("Cadastrar-se", style: TextStyle(
                                  fontSize: 18,
                                  color: Theme
                                      .of(context)
                                      .primaryColor
                              )),
                              color: Colors.white,
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      )
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}
