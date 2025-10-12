import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  bool _menuMatchingActionSearchMatching = false;

  bool get menuMatchingActionSearchMatching =>
      _menuMatchingActionSearchMatching;

  void setMenuMatchingActionSearchMatching(String activeScreen) {
    if (activeScreen == "MATCHING_CHAT") {
      _menuMatchingActionSearchMatching = true;
    }
    notifyListeners();
  }
}
