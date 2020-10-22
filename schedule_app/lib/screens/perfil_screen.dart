import 'package:flutter/material.dart';
import 'package:schedule_app/models/usuario.dart';
import 'package:schedule_app/services/usuario_service.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();

  PerfilScreen();
}

class _PerfilScreenState extends State<PerfilScreen> {

  final usuarioService = UsuarioService();

  Usuario usuario;

  @override
  void initState() {
    super.initState();
    buscarUsuario();
  }

  buscarUsuario() async {
      var a = await usuarioService.getLogado();
    setState(() {
      usuario = a;
    });
  }

  void sair() async {
    // flutter defined function
    bool sair = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Aviso!"),
          content: new Text("Você deseja mesmo sair da conta?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Não"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Sim, sair..."),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if(sair == true) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu perfil"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.account_circle),
                SizedBox(width: 24.0),
                Text("${usuario != null ? usuario.nome : ""}")
              ],
            ),
            SizedBox(height: 16.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.email),
                SizedBox(width: 24.0),
                Text("${usuario != null ? usuario.email : ""}")
              ],
            ),
            Expanded(
              child: Container(
                
              ),
            ),
            RaisedButton(
              onPressed: sair,
              child: Text("Sair da conta", style: TextStyle(color: Colors.white),),
              color: Colors.red[800],
            )
          ],
        ),
      ),
    );
  }
}