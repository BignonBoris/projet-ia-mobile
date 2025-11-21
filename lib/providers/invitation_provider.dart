import 'package:flutter/material.dart';

class InvitationProvider with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void setCount(int data) async {
    _count = data;
    notifyListeners();
  }
}
