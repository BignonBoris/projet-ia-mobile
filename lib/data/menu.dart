import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:projet_ia/screens/chat.dart';
import 'package:projet_ia/screens/sagesse.dart';
import 'package:projet_ia/screens/settings.dart';
import 'package:projet_ia/screens/matching/matching_index.dart';
import 'package:projet_ia/providers/menu_provider.dart';
import 'package:projet_ia/screens/matching/list.dart';

final GlobalKey<SagesseScreenState> sagesseKey =
    GlobalKey<SagesseScreenState>();

final GlobalKey<MatchingScreenState> matchingKey =
    GlobalKey<MatchingScreenState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

var menuProvider = (BuildContext context) => context.watch<MenuProvider>();

// Liste des pages
final List<Map<String, dynamic>> menus = [
  {
    "title": "Discussion",
    "widget": ChatScreen(),
    "actions": (BuildContext context) => <Widget>[],
  },
  {
    "title": "Sagesse",
    "widget": SagesseScreen(key: sagesseKey),
    "actions":
        (BuildContext context) => [
          IconButton(
            icon: const Icon(Icons.refresh), // l'icône reload
            onPressed:
                () => {
                  sagesseKey.currentState?.nextSagesse(),
                }, // recharge les données
            tooltip: 'Recharger',
          ),
        ],
  },
  {
    "title": "Rencontre",
    "widget": MatchingScreen(key: matchingKey),
    "actions":
        (BuildContext context) => [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () async {
              matchingKey.currentState?.pageNavigator();
            },
            tooltip: 'Voir mes match',
          ),
        ],
  },

  {
    "title": "Profil",
    "widget": MatchingScreen(key: matchingKey),
    "actions":
        (BuildContext context) => [
          IconButton(
            icon: const Icon(Icons.people), // l'icône reload
            // onPressed: () {
            //   print("test 2");
            // },
            onPressed: () async {
              matchingKey.currentState?.pageNavigator();
            },
            tooltip: 'Voir mes match',
          ),
        ],
  },
  {
    "title": "Paramètres",
    "widget": SettingsScreen(),
    "actions": [
      IconButton(
        icon: const Icon(Icons.refresh), // l'icône reload
        onPressed: () {
          print("refresh");
        }, // recharge les données
        tooltip: 'Recharger',
      ),
    ],
  },
  // {
  //   "title": "Mots",
  //   "widget": Center(
  //     child: Text("💌 Mots doux… et plus", style: TextStyle(fontSize: 20)),
  //   ),
  // },
];
