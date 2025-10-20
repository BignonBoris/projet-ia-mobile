import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  String pseudo = "";
  String pays = "";
  String phone = "";
  String birth = "";
  String genre = "";
  String profession = "";
  String email = "";
  String password = "";
  String? profileImagePath;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  UserProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      final data = jsonDecode(userData);
      pseudo = data['pseudo'] ?? "";
      pays = data['pays'] ?? "";
      phone = data['phone'] ?? "";
      birth = data['birth'] ?? "";
      genre = data['genre'] ?? "";
      profession = data['profession'] ?? "";
      email = data['email'] ?? "";
      password = data['password'] ?? "";
      profileImagePath = data['profileImagePath'];
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _saveUserToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'pseudo': pseudo,
      'pays': pays,
      'phone': phone,
      'birth': birth,
      'genre': genre,
      'profession': profession,
      'email': email,
      'password': password,
      'profileImagePath': profileImagePath,
    });
    await prefs.setString('user_data', data);
  }

  void updateUser(Map<String, String> updatedData) {
    pseudo = updatedData['pseudo'] ?? pseudo;
    pays = updatedData['pays'] ?? pays;
    phone = updatedData['phone'] ?? phone;
    birth = updatedData['birth'] ?? birth;
    genre = updatedData['genre'] ?? genre;
    profession = updatedData['profession'] ?? profession;
    email = updatedData['email'] ?? email;
    _saveUserToPrefs();
    notifyListeners();
  }

  void updatePassword(String newPassword) {
    password = newPassword;
    _saveUserToPrefs();
    notifyListeners();
  }

  void updateProfileImage(String path) {
    profileImagePath = path;
    _saveUserToPrefs();
    notifyListeners();
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    pseudo = pays = phone = birth = genre = profession = email = password = "";
    profileImagePath = null;
    notifyListeners();
  }
}
