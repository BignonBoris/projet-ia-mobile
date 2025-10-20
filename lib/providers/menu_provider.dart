import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:projet_ia/constants/values.dart";

class MenuProvider with ChangeNotifier {
  bool _menuMatchingActionSearchMatching = false;
  bool _sagesseOnboardingCompleted = false;
  bool _matchingOnboardingCompleted = false;
  String _matchingScreen = "";

  bool get menuMatchingActionSearchMatching =>
      _menuMatchingActionSearchMatching;

  bool get sagesseOnboardingCompleted => _sagesseOnboardingCompleted;
  bool get matchingOnboardingCompleted => _matchingOnboardingCompleted;
  String get matchingScreen => _matchingScreen;

  void setMatchingSelectScreen() {
    _matchingScreen =
        _matchingScreen == matchingFormScreen
            ? matchingListScreen
            : matchingFormScreen;
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
