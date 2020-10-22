import 'package:flutter/material.dart';
import 'package:schedule_app/main.dart';
import 'package:schedule_app/screens/cadastro_agendamento_page.dart';
import 'package:schedule_app/screens/cadastro_participante_page.dart';
import 'package:schedule_app/screens/perfil_screen.dart';
import 'package:schedule_app/services/usuario_service.dart';
import 'package:schedule_app/widgets/lista_agendamento_widget.dart';
import 'package:schedule_app/widgets/lista_participantes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final usuarioService = UsuarioService();

  @override
  void initState() {
    super.initState();
  }

  abrirPerfil() async {
    var sair = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => PerfilScreen()
    ));

    if(sair == true) {
      await usuarioService.logout();
      Navigator.of(context).popAndPushNamed("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/cadastro-agendamento': (context) => CadastroAgendamentoPage(),
        '/cadastro-participante': (context) => CadastroParticipanteScreen(),
      },
      theme: tema,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Reuniões"),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.access_time),
                  text: "Agendamentos",
                ),
                Tab(
                  icon: Icon(Icons.person),
                  text: "Participantes",
                )
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: abrirPerfil,
              )
            ],
          ),
          body: TabBarView(
            children: <Widget>[ListaAgendamento(), ListaParticipantesWidget()],
          ),
        ),
      ),
    );
  }
}
