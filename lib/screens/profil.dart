import 'package:flutter/material.dart';
import 'package:projet_ia/components/start.dart';
import 'package:projet_ia/constants/texts.dart';
import "package:projet_ia/screens/profile/account.dart";

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    final data = introTexts["profil"]!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AccountScreen(),
      // child: StartScreen(
      //   startAction: () => {},
      //   icon: Icons.account_circle_outlined,
      //   title: data["title"]!,
      //   description: data["description"]!,
      //   btnText: "Créer un compte",
      //   btnText2: "J'ai déjà un compte",
      //   startAction2: () => {},
      // ),
    );
  }
}
