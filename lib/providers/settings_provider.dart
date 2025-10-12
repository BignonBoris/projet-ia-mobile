import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  Color userMessageBgColor = Colors.pink[100]!; // Colors.blue[100]!;
  Color aiMessageBgColor = Colors.white; //Colors.grey[200]!;
  Color userMessageColor = Colors.black; //Colors.grey[200]!;
  Color aiMessageColor = Colors.black; //Colors.grey[200]!;

  void setUserMessageColor(Color color) {
    userMessageColor = color;
    notifyListeners();
  }

  void setAiMessageColor(Color color) {
    aiMessageColor = color;
    notifyListeners();
  }

  void setUserMessageBgColor(Color color) {
    userMessageBgColor = color;
    notifyListeners();
  }

  void setAiMessageBgColor(Color color) {
    aiMessageBgColor = color;
    notifyListeners();
  }

  // Color getUserMessageColor() {
  //   notifyListeners();
  //   return userMessageColor;
  // }

  // Color getIaMessageColor() {
  //   notifyListeners();
  //   return aiMessageColor;
  // }
}
