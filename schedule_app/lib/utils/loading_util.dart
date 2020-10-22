import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoadingUtil {
  static ProgressDialog createLoading(BuildContext context, String message) {
    var pr = new ProgressDialog(context, showLogs: true, isDismissible: false);
    pr.style(message: message);
    return pr;
  }
}
