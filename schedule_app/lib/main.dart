import 'package:flutter/material.dart';
import 'package:schedule_app/screens/cadastro_screen.dart';
import 'package:schedule_app/screens/home_screen.dart';
import 'package:schedule_app/screens/load_app_screen.dart';
import 'package:schedule_app/screens/login_screen.dart';
import 'package:schedule_app/services/usuario_service.dart';

void main() {
  runApp(MyApp());
}

final tema = ThemeData(
  primarySwatch: Colors.red,
  accentColor: Colors.red,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final service = UsuarioService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agendamento de reuniões',
      theme: tema,
      initialRoute: "/load",
      routes: {
        '/login': (context) => LoginScreen(),
        '/cadastro': (context) => CadastroScreen(),
        '/home': (context) => HomeScreen(),
        '/load': (context) => LoadAppScreen(),
      },
    );
  }
}
