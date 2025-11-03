import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/components/start.dart';
import 'package:projet_ia/constants/texts.dart';
import "package:projet_ia/constants/values.dart";
import "package:projet_ia/screens/profile/account.dart";
import "package:projet_ia/screens/profile/login.dart";
import "package:projet_ia/screens/profile/generate_qr_screen.dart";
import "package:projet_ia/screens/profile/scan_qr_screen.dart";
import 'package:projet_ia/providers/menu_provider.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => ProfilScreenState();
}

class ProfilScreenState extends State<ProfilScreen> {
  bool isLoading = true;
  bool profilOnBoardingCompleted = false;
  String currentScreen = "";
  MenuProvider menuProvider = MenuProvider();

  void init() async {
    menuProvider = context.read<MenuProvider>();
    final prefs = await SharedPreferences.getInstance();
    print("print(menuProvider.profilScreen); = ${menuProvider.profilScreen}");
    setState(() {
      isLoading = false;
      profilOnBoardingCompleted = prefs.getBool('profil_onboarding') ?? false;
      currentScreen = menuProvider.profilScreen;
    });
  }

  void initState() {
    super.initState();
    init();
  }

  void changeScreen({String screen = ""}) {
    menuProvider.completeProfilOnboarding();
    menuProvider.setProfilSelectScreen(screen: screen);
    // print(menuProvider.profilScreen);
    print("screen = $screen");
    setState(() {
      currentScreen = menuProvider.profilScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = introTexts["profil"]!;
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : currentScreen == profilAccountScreen
        ? AccountScreen()
        : currentScreen == profilLoginScreen
        ? LoginScreen()
        : currentScreen == profilQRScreen
        ? GenerateQRScreen()
        : currentScreen == profilScannerScreen
        ? ScanQRScreen()
        : profilOnBoardingCompleted
        ? AccountScreen()
        : Padding(
          padding: const EdgeInsets.all(16.0),
          // child: AccountScreen(),
          child: StartScreen(
            startAction: () => {changeScreen(screen: profilAccountScreen)},
            icon: Icons.account_circle_outlined,
            title: data["title"]!,
            description: data["description"]!,
            btnText: "Créer un compte",
            btnText2: "J'ai déjà un compte",
            startAction2: () => {changeScreen(screen: profilLoginScreen)},
          ),
        );
  }
}
