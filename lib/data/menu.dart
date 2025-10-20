import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:projet_ia/screens/chat.dart';
import 'package:projet_ia/screens/sagesse.dart';
import 'package:projet_ia/screens/settings.dart';
import 'package:projet_ia/screens/profil.dart';
import 'package:projet_ia/screens/matching/matching_index.dart';
import 'package:projet_ia/providers/menu_provider.dart';
import 'package:projet_ia/screens/matching/list.dart';
import "package:projet_ia/constants/values.dart";

final GlobalKey<SagesseScreenState> sagesseKey =
    GlobalKey<SagesseScreenState>();

final GlobalKey<MatchingScreenState> matchingKey =
    GlobalKey<MatchingScreenState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// var menuProvider = (BuildContext context) => context.watch<MenuProvider>();

// Liste des pages
final List<Map<String, dynamic>> menus = [
  {
    "title": "Rencontre",
    "widget": MatchingScreen(key: matchingKey),
    "actions": (BuildContext context) {
      final menuProvider = context.watch<MenuProvider>();
      menuProvider.loadMatchingOnboardingStatus();
      List<Widget> subActions = [];
      if (menuProvider.matchingOnboardingCompleted) {
        subActions.add(
          IconButton(
            icon:
                menuProvider.matchingScreen == matchingFormScreen
                    ? const Icon(Icons.people)
                    : const Icon(Icons.ac_unit),
            onPressed: () async {
              matchingKey.currentState?.pageNavigator(context);
            },
            tooltip: 'Voir mes match',
          ),
        );
      }
      return subActions;
    },
  },

  {
    "title": "Sagesse",
    "widget": SagesseScreen(key: sagesseKey),
    "actions": (BuildContext context) {
      final menuProvider = context.watch<MenuProvider>();
      menuProvider.loadSagesseOnboardingStatus();
      List<Widget> subActions = [];
      if (menuProvider.sagesseOnboardingCompleted) {
        subActions.add(
          IconButton(
            icon: const Icon(Icons.refresh), // l'icône reload
            onPressed:
                () => {
                  sagesseKey.currentState?.nextSagesse(),
                }, // recharge les données
            tooltip: 'Recharger',
          ),
        );
      }
      return subActions;
    },
  },
  {
    "title": "Discussion",
    "widget": ChatScreen(),
    "actions": (BuildContext context) => <Widget>[],
  },
  {
    "title": "Profil",
    "widget": ProfilScreen(),
    "actions": (BuildContext context) => <Widget>[],
  },
  {
    "title": "Paramètres",
    "widget": SettingsScreen(),
    "actions":
        (BuildContext context) => <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.refresh), // l'icône reload
          //   onPressed: () {
          //     print("refresh");
          //   }, // recharge les données
          //   tooltip: 'Recharger',
          // ),
        ],
  },
  // {
  //   "title": "Mots",
  //   "widget": Center(
  //     child: Text("💌 Mots doux… et plus", style: TextStyle(fontSize: 20)),
  //   ),
  // },
];
