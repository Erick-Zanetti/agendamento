import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:schedule_app/models/response.dart';

class ApiService {
  var client = http.Client();

  String url;

  // final String _url = "https://obscure-dawn-52676.herokuapp.com/api";
  final String _url = "http://192.168.0.115:8080/api";

  ApiService(String endpoint) {
    url = _url + "/" + endpoint;
  }

  Map<String, String> getHeaders() {
    return {"Content-Type": "application/json"};
  }

  Future<http.Response> request(String api) {
    print(api);
    return http.get(api);
  }

  Future<http.Response> post(String url, Map<String, dynamic> map) {
    print(url);
    var body = json.encode(map);
    return http.post(url, headers: getHeaders(), body: body);
  }

  Future<http.Response> put(String url, Map<String, dynamic> map) {
    print(url);
    var body = json.encode(map);
    return http.put(url, headers: getHeaders(), body: body);
  }

  Response<dynamic> send(http.Response res) {
    if (res.statusCode == 400) {
      throw Response.fromJson(json.decode(res.body));
    } else if (res.statusCode == 200) {
      return Response.fromJson(json.decode(res.body));
    } else {
      Response response = Response();
      response.message = "Estamos com problemas técnicos, favor chamar o suporte.";
      response.hasError = true;
      throw response;
    }
  }
}
