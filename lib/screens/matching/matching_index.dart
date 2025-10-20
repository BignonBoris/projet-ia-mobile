import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projet_ia/screens/matching/form.dart';
import 'package:projet_ia/screens/matching/list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/providers/menu_provider.dart';
import 'package:projet_ia/constants/values.dart';
import 'intro.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => MatchingScreenState();
}

class MatchingScreenState extends State<MatchingScreen> {
  bool isLoading = true;
  bool matchingOnBoardingCompleted = false;
  String currentScreen = "";
  MenuProvider menuProvider = MenuProvider();

  void pageNavigator(BuildContext context) {
    menuProvider = context.read<MenuProvider>();
    menuProvider.setMatchingSelectScreen();
    if (mounted) {
      setState(() {
        currentScreen = menuProvider.matchingScreen;
      });
    }
  }

  void init() async {
    menuProvider = context.read<MenuProvider>();
    final prefs = await SharedPreferences.getInstance();
    print(menuProvider.matchingScreen);
    setState(() {
      isLoading = false;
      matchingOnBoardingCompleted =
          prefs.getBool('matching_onboarding') ?? false;
      currentScreen = menuProvider.matchingScreen;
    });
  }

  void initState() {
    super.initState();
    init();
  }

  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : Navigator(
          key: ValueKey({
            currentScreen,
            matchingOnBoardingCompleted,
          }), // 👈 change à chaque valeur
          onGenerateRoute: (settings) {
            if (currentScreen == matchingFormScreen) {
              return MaterialPageRoute(builder: (_) => MatchingFormScreen());
            } else if (currentScreen == matchingListScreen) {
              return MaterialPageRoute(builder: (_) => MatchingListScreen());
            } else if (!matchingOnBoardingCompleted) {
              return MaterialPageRoute(builder: (_) => MatchingIntroScreen());
            } else {
              return MaterialPageRoute(builder: (_) => MatchingFormScreen());
            }

            // switch (currentScreen) {
            //   case matchingFormScreen:
            //     return MaterialPageRoute(builder: (_) => MatchingFormScreen());
            //   case matchingListScreen:
            //     return MaterialPageRoute(builder: (_) => MatchingListScreen());
            //   // case "CHAT":
            //   //   return MaterialPageRoute(
            //   //     builder: (_) => MatchingChatScreen("userName": "Truman"),
            //   //   );
            //   default:
            //     return MaterialPageRoute(builder: (_) => MatchingIntroScreen());
            // }
          },
        );
  }
}
