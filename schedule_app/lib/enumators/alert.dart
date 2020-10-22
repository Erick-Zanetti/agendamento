import 'package:enum_to_string/enum_to_string.dart';
import 'package:schedule_app/enumators/alert_icon.dart';

class Alert {
  
  String title;
  String message;
  AlertIcon icon;

  Alert.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
    if(json['icon']) {
      icon = EnumToString.fromString(AlertIcon.values, json['icon']);
    }
  }
}