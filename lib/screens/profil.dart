import 'package:flutter/material.dart';
import 'package:projet_ia/providers/user_provider.dart';
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
import "package:projet_ia/constants/values.dart";
import "package:projet_ia/services/users.dart";
import 'package:projet_ia/classes/user.dart';

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
  UserProvider userProvider = UserProvider();
  UserService userService = UserService();
  String? userId = "";

  void init() async {
    // menuProvider = context.read<MenuProvider>();
    // userProvider = context.read<UserProvider>();
    final prefs = await SharedPreferences.getInstance();
    userId = await getPrefUserId();
    if (userId != "" || userId != null) {
      setState(() {
        isLoading = false;
        profilOnBoardingCompleted = prefs.getBool('profil_onboarding') ?? false;
        currentScreen =
            menuProvider.profilScreen == "" ||
                    menuProvider.profilScreen == profilAccountScreen ||
                    menuProvider.profilScreen == profilLoginScreen
                ? menuProvider.profilScreen
                : profilAccountScreen;
      });
    } else {
      final response = await userService.createUser(new UserModel.empty());
      if (response.length == 36) {
        userProvider.setUserId(response);
        setState(() {
          isLoading = false;
          profilOnBoardingCompleted =
              prefs.getBool('profil_onboarding') ?? false;
          currentScreen = menuProvider.profilScreen;
        });
      }
    }
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
    userProvider = context.watch<UserProvider>();
    menuProvider = context.watch<MenuProvider>();
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : currentScreen == profilAccountScreen
        ? AccountScreen()
        : currentScreen == profilLoginScreen && userProvider.pseudo == ""
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
