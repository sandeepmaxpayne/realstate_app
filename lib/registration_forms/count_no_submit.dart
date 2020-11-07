import 'package:flutter/foundation.dart';

class CountNoOfSubmit extends ChangeNotifier {
  int count = 0;

  void changeNoOfCount(int count) {
    this.count = count;
    notifyListeners();
  }
}
