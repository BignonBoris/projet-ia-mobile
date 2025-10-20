import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/components/start.dart';
import 'package:projet_ia/constants/texts.dart';
import 'package:projet_ia/providers/menu_provider.dart';
import './form.dart';

//
// 1️⃣ INTRO SCREEN
//
class MatchingIntroScreen extends StatelessWidget {
  MatchingIntroScreen({super.key});

  MenuProvider menuProvider = MenuProvider();

  void startMatching(BuildContext context) async {
    menuProvider = context.read<MenuProvider>();
    await menuProvider.completeMatchingOnboarding();
    menuProvider.setMatchingSelectScreen();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MatchingFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = introTexts["matching"]!;
    return StartScreen(
      startAction: () => startMatching(context),
      icon: Icons.favorite,
      title: data["title"],
      description: data["description"],
      // "Découvrez des personnes qui partagent vos besoins et envies 💕",
      btnText: "Commencer",
    );

    // Center(
    //   child: Padding(
    //     padding: const EdgeInsets.all(20),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const Icon(Icons.favorite, size: 120, color: Colors.pink),
    //         const SizedBox(height: 20),
    //         const Text(
    //           "Découvrez des personnes qui partagent vos besoins et envies 💕",
    //           textAlign: TextAlign.center,
    //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //         ),
    //         const SizedBox(height: 40),
    //         Button(
    //           callAction: () {
    //             startMatching(context);
    //           },
    //           backgroundColor: Colors.blue,
    //           label: "Commencer",
    //         ),
    //         ElevatedButton(
    //           style: ElevatedButton.styleFrom(
    //             backgroundColor: Colors.pinkAccent,
    //           ),
    //           onPressed: () async {
    //             final prefs = await SharedPreferences.getInstance();
    //             prefs.setBool('matching_onbording', false);

    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(builder: (context) => MatchingFormScreen()),
    //             );
    //           },
    //           child: const Text("Commencer"),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
