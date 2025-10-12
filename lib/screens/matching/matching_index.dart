import 'package:flutter/material.dart';
import 'package:projet_ia/screens/matching/form.dart';
import 'package:projet_ia/screens/matching/list.dart';
import 'package:projet_ia/screens/matching/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'intro.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => MatchingScreenState();
}

class MatchingScreenState extends State<MatchingScreen> {
  final String FORM = "FORM";
  final String LIST = "LIST";
  final String CHAT = "CHAT";

  bool isLoading = true;
  bool is_onbording = true;
  String currentScreen = "FORM";

  void pageNavigator() {
    print(currentScreen);
    if (currentScreen == "FORM") {
      setState(() {
        currentScreen = "LIST";
      });
    } else if (currentScreen == "LIST") {
      setState(() {
        currentScreen = "FORM";
      });
    } else {
      setState(() {
        currentScreen = "LIST";
      });
    }
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('matching_onbording'));
    setState(() {
      isLoading = false;
      is_onbording = prefs.getBool('matching_onbording') ?? true;
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
            is_onbording,
          }), // 👈 change à chaque valeur
          onGenerateRoute: (settings) {
            if (is_onbording) {
              return MaterialPageRoute(builder: (_) => MatchingIntroScreen());
            }

            switch (currentScreen) {
              case "FORM":
                return MaterialPageRoute(builder: (_) => MatchingFormScreen());
              case "LIST":
                return MaterialPageRoute(builder: (_) => MatchingListScreen());
              // case "CHAT":
              //   return MaterialPageRoute(
              //     builder: (_) => MatchingChatScreen("userName": "Truman"),
              //   );
              default:
                return MaterialPageRoute(
                  builder: (_) => const MatchingListScreen(),
                );
            }
          },
        );
  }
}
