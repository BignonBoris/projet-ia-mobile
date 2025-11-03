import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:projet_ia/constants/values.dart";

class MenuProvider with ChangeNotifier {
  bool _menuMatchingActionSearchMatching = false;
  bool _sagesseOnboardingCompleted = false;
  bool _matchingOnboardingCompleted = false;
  bool _profilOnboardingCompleted = false;
  String _matchingScreen = "";
  String _profilScreen = "";

  bool get menuMatchingActionSearchMatching =>
      _menuMatchingActionSearchMatching;

  bool get sagesseOnboardingCompleted => _sagesseOnboardingCompleted;
  bool get matchingOnboardingCompleted => _matchingOnboardingCompleted;
  bool get profilOnboardingCompleted => _profilOnboardingCompleted;
  String get matchingScreen => _matchingScreen;
  String get profilScreen => _profilScreen;

  void setMatchingSelectScreen() {
    _matchingScreen =
        _matchingScreen == matchingListScreen
            ? matchingFormScreen
            : matchingListScreen;
  }

  void setProfilSelectScreen({String screen = ""}) {
    _profilScreen =
        screen != ""
            ? screen
            : _profilScreen == profilAccountScreen
            ? profilLoginScreen
            : profilAccountScreen;
  }

  Future<void> loadProfilOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _profilOnboardingCompleted = prefs.getBool('profil_onboarding') ?? false;
    notifyListeners(); // Informe les widgets que l'état a changé
  }

  Future<void> completeProfilOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profil_onboarding', true);
    _profilOnboardingCompleted = true;
    notifyListeners(); // Informe les widgets que l'état a changé
  }

  void setMenuMatchingActionSearchMatching(String activeScreen) {
    if (activeScreen == "MATCHING_CHAT") {
      _menuMatchingActionSearchMatching = true;
    }
    notifyListeners();
  }

  Future<void> loadSagesseOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _sagesseOnboardingCompleted = prefs.getBool('sagesse_onboarding') ?? false;
    notifyListeners(); // Informe les widgets que l'état a changé
  }

  Future<void> completeSagesseOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sagesse_onboarding', true);
    _sagesseOnboardingCompleted = true;
    notifyListeners(); // Informe les widgets que l'état a changé
  }

  Future<void> loadMatchingOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _matchingOnboardingCompleted =
        prefs.getBool('matching_onboarding') ?? false;
    notifyListeners(); // Informe les widgets que l'état a changé
  }

  Future<void> completeMatchingOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('matching_onboarding', true);
    _matchingOnboardingCompleted = true;
    notifyListeners(); // Informe les widgets que l'état a changé
  }
}
