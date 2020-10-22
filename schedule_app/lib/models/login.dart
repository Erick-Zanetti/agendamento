class Login {
  String login;
  String senha;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['login'] = login;
    json['senha'] = senha;
    return json;
  }
}