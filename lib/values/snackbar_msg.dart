import 'package:flutter/material.dart';

class SnackBarMessage {
  final String message;
  final Color color;
  final loginScaffoldKey;
  SnackBarMessage(
      {@required this.message,
      @required this.color,
      @required this.loginScaffoldKey});

  getMessage() {
    return loginScaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      backgroundColor: color,
      behavior: SnackBarBehavior.fixed,
    ));
  }
}
