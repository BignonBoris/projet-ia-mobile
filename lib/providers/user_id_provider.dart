// lib/providers/user_id_provider.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserIdProvider with ChangeNotifier {
  String _userId = "";

  String get userId => _userId;

  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }

  void generateId() {
    if (_userId.isEmpty) {
      _userId = const Uuid().v4();
      notifyListeners();
    }
  }

  // Future<void> loadUserId() async {
  //   _userId = await UserIdService.getOrCreateUserId();
  //   notifyListeners();
  // }
}
