import 'package:flutter/material.dart';
import 'package:projet_ia/classes/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  UserModel user = UserModel.empty();
  String? user_id = "";
  String pseudo = "";
  String country = "";
  String phone = "";
  String dateOfBirth = "";
  String sexe = "";
  String occupation = "";
  String email = "";
  String password = "";
  String? profileImagePath;
  String _userId = "";

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  UserProvider() {
    _loadUserFromPrefs();
  }

  // UserModel get getUser => user;
  String? getUserId() {
    print("get");
    return user.user_id;
  }

  // String? get getUserId => user.user_id;

  String get userId => _userId;

  void setUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding_done', id);
    _userId = id;
    notifyListeners();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      final data = jsonDecode(userData!);

      pseudo = data['pseudo'] ?? "";
      country = data['country'] ?? "";
      phone = data['phone'] ?? "";
      dateOfBirth = data['dateOfBirth'] ?? "";
      sexe = data['sexe'] ?? "";
      occupation = data['occupation'] ?? "";
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
      'country': country,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'sexe': sexe,
      'occupation': occupation,
      'email': email,
      'password': password,
      'profileImagePath': profileImagePath,
    });
    await prefs.setString('user_data', data);
  }

  // void updateUser(Map<String, String> updatedData) {
  void updateUser(Map<String, dynamic> updatedData) {
    pseudo = updatedData['pseudo'] ?? pseudo;
    country = updatedData['country'] ?? country;
    phone = updatedData['phone'] ?? phone;
    dateOfBirth = updatedData['dateOfBirth'] ?? dateOfBirth;
    sexe = updatedData['sexe'] ?? sexe;
    occupation = updatedData['occupation'] ?? occupation;
    email = updatedData['email'] ?? email;
    profileImagePath = updatedData["profileImageUrl"] ?? profileImagePath;
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
    // await prefs.remove("onboarding_done");
    pseudo =
        country =
            phone = dateOfBirth = sexe = occupation = email = password = "";
    profileImagePath = null;
    notifyListeners();
  }

  // Future<void> setUserToProvider(Map<String, dynamic>? data) async {
  Future<void> setUserToProvider(UserModel? data) async {
    if (data != null) {
      user.user_id = data.user_id;
      user.image = data.image;
      user.pseudo = data.pseudo;
      user.phone = data.phone;
      user.dateOfBirth = data.dateOfBirth;
      user.sexe = data.sexe;
      user.occupation = data.occupation;
      user.email = data.email;
      user.password = data.password;
      user.name = data.name;
      user.age = data.age;
      user.country = data.country;
      user.fcmToken = data.fcmToken;
    }
    notifyListeners();
  }
}
