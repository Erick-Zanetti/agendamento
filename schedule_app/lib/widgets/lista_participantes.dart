import 'package:flutter/material.dart';
import 'package:schedule_app/models/participante.dart';
import 'package:schedule_app/models/response.dart';
import 'package:schedule_app/models/usuario.dart';
import 'package:schedule_app/screens/cadastro_participante_page.dart';
import 'package:schedule_app/services/participante_service.dart';
import 'package:schedule_app/services/usuario_service.dart';

class ListaParticipantesWidget extends StatefulWidget {
  @override
  _ListaParticipantesWidgetState createState() => _ListaParticipantesWidgetState();

  bool search = false;
  List<int> selectedList = List();

  ListaParticipantesWidget({this.search, this.selectedList}) : super() {
    this.search = (this.search.runtimeType == bool ? this.search : false);
  }
}

class _ListaParticipantesWidgetState extends State<ListaParticipantesWidget> {
  final service = ParticipanteService();
  TextEditingController controller = new TextEditingController(text: '');
  final List<Participante> _searchLista = List();
  final usuarioService = UsuarioService();

  Usuario usuario;

  @override
  void initState() {
    super.initState();
    buscarUsuario().then((value) {
      carregarParticipantes().then((value) => value).catchError((onError) => print(onError));
    });
  }

  Future<List<Participante>> carregarParticipantes() async {
    String text = controller.text.toString();
    Response<List<Participante>> res = await service.pesquisa(text, usuario.id);
    this._searchLista.clear();
    this._searchLista.addAll(res.data);
    setState(() {});
    return this._searchLista;
  }

  Future<void> buscarUsuario() async {
    Usuario a = await usuarioService.getLogado();
    setState(() {
      usuario = a;
    });
  }

  novo() async {
    await Navigator.pushNamed(context, "/cadastro-participante");
    setState(() {});
  }

  editar(Participante obj) async {
    await Navigator.push(context, MaterialPageRoute(builder: (ctx) => CadastroParticipanteScreen(id: obj.id)));
    setState(() {});
  }

  doneList() {
    List<Participante> returnList = List();
    this.carregarParticipantes().then((value) {
      this._searchLista.forEach((element) {
        if (this.isSelected(element.id)) {
          returnList.add(element);
        }
      });
      Navigator.of(context).pop(returnList);
    });
  }

  bool isSelected(int id) {
    return this.widget.selectedList.contains(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: (this.widget.search ? 32.0 : 0.0),
            ),
            color: Theme.of(context).primaryColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(hintText: 'Buscar', border: InputBorder.none),
                    onChanged: (text) {
                      carregarParticipantes();
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 80.0,
            ),
            child: FutureBuilder(
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: this._searchLista.length,
                  itemBuilder: (context, index) {
                    if (this.widget.search) {
                      return CheckboxListTile(
                        title: Text(this._searchLista[index].nome),
                        subtitle: Text(this._searchLista[index].email),
                        value: this.isSelected(this._searchLista[index].id),
                        onChanged: (bool value) {
                          setState(() {
                            if (this.isSelected(this._searchLista[index].id)) {
                              this.widget.selectedList.remove(this._searchLista[index].id);
                            } else {
                              this.widget.selectedList.add(this._searchLista[index].id);
                            }
                          });
                        },
                      );
                    } else {
                      return ListTile(
                        title: Text(this._searchLista[index].nome),
                        subtitle: Text(this._searchLista[index].email),
                        leading: Icon(Icons.person),
                        onTap: () {
                          editar(this._searchLista[index]);
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: (this.widget.search
          ? FloatingActionButton(
              onPressed: doneList,
              child: Icon(Icons.done),
              backgroundColor: Theme.of(context).accentColor,
            )
          : FloatingActionButton(
              onPressed: novo,
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).accentColor,
            )),
    );
  }
}
