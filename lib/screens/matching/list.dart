import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projet_ia/services/matching.dart';
import 'package:projet_ia/screens/matching/list_screen/matchs.dart';
import 'package:projet_ia/screens/matching/list_screen/invitations.dart';
import 'package:projet_ia/screens/matching/list_screen/messages.dart';
import "package:projet_ia/constants/values.dart";
import "package:projet_ia/services/connexion.dart";
import "package:projet_ia/services/invitation.dart";
import 'package:projet_ia/components/unread_message.dart';
import "package:projet_ia/providers/invitation_provider.dart";

//
// 3️⃣ LIST SCREEN
//

class MatchingListScreen extends StatefulWidget {
  const MatchingListScreen({super.key});

  @override
  State<MatchingListScreen> createState() => _MatchingListScreenState();
}

class _MatchingListScreenState extends State<MatchingListScreen>
    with SingleTickerProviderStateMixin {
  final IAMatchingService iaMatchingService = IAMatchingService();
  late TabController _tabController;

  List<Map<String, dynamic>> connexions = [];

  String uniqueId = "";
  bool isLoading = true;

  void init() async {
    List<dynamic> invitations = [];
    final String? userId = await getPrefUserId();
    connexions = await ConnexionService().getAllUserConnexions(userId!);
    invitations = await InvitationService().getAllInvitations(userId);
    context.read<InvitationProvider>().setCount(invitations.length);
    setState(() {
      connexions = connexions;
      isLoading = false;
      _tabController.index = connexions.isEmpty ? 2 : 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // valeur par défaut
    Future.microtask(() => init());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invitationProvider = context.watch<InvitationProvider>();

    return DefaultTabController(
      length: 3, // nombre d’onglets
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48), // hauteur de la TabBar
          child: Container(
            color: Colors.pinkAccent, // couleur de fond
            child: SafeArea(
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(text: "Messages"),
                  invitationProvider.count == 0
                      ? Tab(text: "Invitations")
                      : Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize:
                                MainAxisSize
                                    .min, // 👈 empêche le Row de s'étirer
                            children: [
                              Text("Invitations"),
                              SizedBox(width: 20),
                              SimpleBadge(
                                count: invitationProvider.count,
                                bgColor: Colors.white,
                                textColor: Colors.redAccent,
                              ),
                            ],
                          ),
                        ),
                      ),
                  Tab(text: "Matchs"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
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
