class Usuario {
  int id;
  String nome;
  String email;
  String senha;

  Usuario();

  Usuario.fromJson(Map<String, dynamic> json) {
    if(json != null) {
      id = json['id'];
      nome = json['nome'];
      email = json['email'];
      senha = json['senha'];
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['id'] = id;
    json['nome'] = nome;
    json['email'] = email;
    json['senha'] = senha;
    return json;
  }
}