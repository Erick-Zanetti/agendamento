import 'package:flutter/material.dart';
import 'package:schedule_app/models/usuario.dart';
import 'package:schedule_app/services/usuario_service.dart';

class LoadAppScreen extends StatefulWidget {
  @override
  _LoadAppScreenState createState() => _LoadAppScreenState();
}

class _LoadAppScreenState extends State<LoadAppScreen> {

  final service = UsuarioService();

  @override
  void initState() {
    super.initState();
    this.carregarInfo();
  }

  void carregarInfo() {
    service.getLogado().then((value) => posAutenticar(value)).catchError((error){
      print(error);
    });
  }

  posAutenticar(Usuario usuario) {
    if(usuario == null) {
      Navigator.of(context).pushNamed("/login");
    } else {
      Navigator.of(context).pushNamed("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                child: Text("Carregando suas configurações..."),
                padding: EdgeInsets.only(top: 24.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}