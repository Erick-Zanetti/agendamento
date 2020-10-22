import 'package:enum_to_string/enum_to_string.dart';
import 'package:schedule_app/enumators/alert.dart';
import 'package:schedule_app/enumators/response_type.dart';

class Response<T> {
  String message;
  ResponseType tipo;
  bool hasError;
  T data;
  Alert alert;

  Response();

  Response.messageError(String message) {
    this.message = message;
    this.hasError = true;
  }

  Response.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    tipo = EnumToString.fromString(ResponseType.values, json['tipo']);
    hasError = json['hasError'];
  }
}