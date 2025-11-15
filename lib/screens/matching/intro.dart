import 'package:flutter/material.dart';
import 'package:projet_ia/constants/values.dart';
import 'package:projet_ia/screens/home.dart';
import 'package:projet_ia/screens/matching/list.dart';
import 'package:projet_ia/screens/matching/form.dart';
import 'package:provider/provider.dart';
import 'package:projet_ia/components/start.dart';
import 'package:projet_ia/constants/texts.dart';
import 'package:projet_ia/constants/values.dart';
import 'package:projet_ia/services/matching.dart';
import 'package:projet_ia/providers/menu_provider.dart';
import 'package:projet_ia/providers/user_provider.dart';
import "package:projet_ia/services/users.dart";
import "package:projet_ia/classes/user.dart";
import "package:projet_ia/utils.dart";
import './form.dart';

//
// 1️⃣ INTRO SCREEN
//
class MatchingIntroScreen extends StatelessWidget {
  MatchingIntroScreen({super.key});

  MenuProvider menuProvider = MenuProvider();
  UserProvider userProvider = UserProvider();
  UserModel user = UserModel();
  UserService userService = UserService();

  void showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Permet de fermer en tapant à l'extérieur
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, size: 50, color: Colors.pinkAccent),
                const SizedBox(height: 12),
                const Text(
                  "Complétez votre profil 📝",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Completer les informations suivantes dans profil / mon compte",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "${(userProvider.pseudo == '' || userProvider.pseudo.isEmpty) ? '- Nom d\'utilisateur  ' : ''}"
                  "${(userProvider.dateOfBirth == '' || userProvider.dateOfBirth.isEmpty) ? '- Date de naissance  ' : ''}"
                  "${(userProvider.country == '' || userProvider.country.isEmpty) ? '- Pays  ' : ''}"
                  "${(userProvider.sexe == '' || userProvider.sexe.isEmpty) ? '- Sexe  ' : ''}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Afin de vous permettra de profiter pleinement de notre système de matching "
                  "et de rencontrer des personnes partageant les mêmes centres d'intérêt que vous 💫",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Souhaitez-vous mettre à jour votre profil maintenant ?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[800],
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const SizedBox(
                        width: 70,
                        child: Center(child: Text("Plus tard")),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(selectedIndex: 3),
                          ),
                        );
                      },
                      child: const SizedBox(
                        width: 70,
                        child: Center(
                          child: Text(
                            "Oui",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void startMatching(BuildContext context) async {
    menuProvider = context.read<MenuProvider>();

    String? userId = await getPrefUserId();

    UserModel? user = await userService.getUser(userId!);

    if (checkUserProfilComplet(user)) {
      await menuProvider.completeMatchingOnboarding();
      menuProvider.setMatchingSelectScreen();
      // await matchingFormKey.currentState?.init();
      await IAMatchingService().initMatching(userId);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MatchingListScreen()),
      );
    } else {
      showProfileDialog(context);
    }
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
