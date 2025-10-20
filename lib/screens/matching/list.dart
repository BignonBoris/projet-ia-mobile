import 'package:flutter/material.dart';
import 'package:projet_ia/services/matching.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/screens/matching/list_screen/matchs.dart';
import 'package:projet_ia/screens/matching/list_screen/invitations.dart';
import 'package:projet_ia/screens/matching/list_screen/messages.dart';

//
// 3️⃣ LIST SCREEN
//

class MatchingListScreen extends StatefulWidget {
  const MatchingListScreen({super.key});

  @override
  State<MatchingListScreen> createState() => _MatchingListScreenState();
}

class _MatchingListScreenState extends State<MatchingListScreen> {
  final IAMatchingService iaMatchingService = IAMatchingService();

  List<dynamic> users = [];

  String uniqueId = "";
  bool isLoading = true;

  // void init() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   uniqueId = prefs.getString('onboarding_done') ?? "";
  //   final response = await iaMatchingService.searchMatching(uniqueId);
  //   print(response);
  //   setState(() {
  //     users = response;
  //     isLoading = response.isNotEmpty ? false : true;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // Future.microtask(() => init());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // nombre d’onglets
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48), // hauteur de la TabBar
          child: Container(
            color: Colors.pinkAccent, // couleur de fond
            child: const SafeArea(
              child: TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(text: "Messages"),
                  Tab(text: "Invitations"),
                  Tab(text: "Matchs"),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            MatchingListContactsScreen(),
            MatchingListInvitationsScreen(),
            MatchingListMatchsScreen(),
          ],
        ),
      ),
    );
  }
}
