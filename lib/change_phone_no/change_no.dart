import 'package:flutter/foundation.dart';

class ChangeEmailAddress extends ChangeNotifier {
  String emailAddress = "abc@gmail.com";

  void changeData(String newData) {
    emailAddress = newData;
    notifyListeners();
  }
}
