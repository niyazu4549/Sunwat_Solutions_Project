import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  void refreshWidget() {
    return notifyListeners();
  }
}
