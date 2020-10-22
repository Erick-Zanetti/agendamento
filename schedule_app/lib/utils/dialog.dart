import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:schedule_app/enumators/response_type.dart';
import 'package:schedule_app/models/response.dart';

class DialogUtil {
  static Future alert({
    @required String title,
    @required String description,
    @required BuildContext context,
    String action,
    String message
  }) {
    return showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(
        title: Text(title),
        content: Padding(
          padding: EdgeInsets.all(16),
          child: Text(message != null ? message : description),
        ),
        actions: <Widget>[
          FlatButton(
            child: new Text(action != null ? action : "Fechar"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      );
    });
  }

  static Future showResponse({@required Response response, @required BuildContext context, String message}) {
    String title = response.hasError ? "Ops!" : "Sucesso!";
    switch(response.tipo) {
      case ResponseType.ALERT_ERROR:
        return _alertError(response, context);
      case ResponseType.ALERT_SUCCESS:
        return _alertSucess(response, context);
      case ResponseType.CAMPOS_INVALIDOS:
        return _camposInvalidos(response, context);
      case ResponseType.EXCEPTION:
        return _exception(response, context);
      case ResponseType.SUCCESS:
        return alert(title: title, description: message != null ? message : response.message, context: context);
      case ResponseType.VALIDATION:
        return _validation(response, context);
      case ResponseType.MESSAGE_SUCCESS:
        return _messageSucess(response, context);
    }
    return alert(title: title, description: message != null ? message : response.message, context: context);
  }

  static Future showError(dynamic error, BuildContext context) {
    if (error is Response) {
      return showResponse(response: error, context: context);
    } else {
      return getdefaultError(context);
    }
  }

  static Future _alertError(Response res, BuildContext ctx) {
    // TODO implemntar ícone
    return alert(
      context: ctx,
      title: "Ops! Ocorreu um erro.",
      description: res.message,
    );
  }

  static Future _alertSucess(Response res, BuildContext ctx) {
    // TODO implementar o ícone
    return alert(
      context: ctx,
      title: res.alert.title,
      description: res.alert.message,
    );
  }

  static Future _camposInvalidos(Response res, BuildContext ctx) {
    return alert(
      context: ctx,
      title: "Inválido!",
      description: res.message
    );
  }

  static Future _exception(Response res, BuildContext ctx) {
    return alert(
      context: ctx,
      title: "Ops! tivemos uma falha.",
      description: res.message
    );
  }

  static Future _validation(Response res, BuildContext ctx) {
    return alert(
      context: ctx,
      title: "Inválido!",
      description: res.message
    );
  }

  static Future _messageSucess(Response res, BuildContext ctx) {
    final snackBar = SnackBar(
      content: Text(res.message),
      duration: Duration(seconds: 5),
    );
    Scaffold.of(ctx).showSnackBar(snackBar);
    return null;
  }

  static Future getdefaultError(BuildContext context) {
    return alert(title: "Ops!", description: "Ocorreu uma falha inesperada, favor contactar o suporte.", context: context);
  }
}