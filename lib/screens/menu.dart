import 'package:flutter/material.dart';
import "sagesse.dart";
import "home.dart";
import "settings.dart";
import "quiz.dart";
// import "sms.dart";

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.pink),
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Accueil"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              // Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.lightbulb_outline),
            title: const Text("Sagesse du jour"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SagesseScreen()),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.favorite_border),
          //   title: const Text("Quiz de l’amour"),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => QuizScreen()),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.mail_outline),
          //   title: const Text("Mots doux… et plus"),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SmsScreen()),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Paramètres"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Déconnexion"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
