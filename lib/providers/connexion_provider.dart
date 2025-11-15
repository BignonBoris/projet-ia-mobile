import 'package:flutter/material.dart';

class ConnexionProvider with ChangeNotifier {
  List<dynamic> _connexions = [];

  // UserModel get getUser => user;
  List<dynamic> getConnexions() {
    return _connexions;
  }

  List<dynamic> get connexions => _connexions;

  void setConnexions(List<dynamic> data) async {
    print("data");
    print(data);
    _connexions = data;
    notifyListeners();
  }
}
