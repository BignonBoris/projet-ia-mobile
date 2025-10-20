import 'package:flutter/material.dart';
import 'package:projet_ia/services/invitation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/components/empty_list.dart';
import 'package:projet_ia/classes/maching_guest_input.dart';
import 'package:projet_ia/components/toast.dart';
// import './chat.dart';
import "package:projet_ia/components/matching/show_details.dart";

//
// 3️⃣ LIST SCREEN
//

class MatchingListInvitationsScreen extends StatefulWidget {
  const MatchingListInvitationsScreen({super.key});

  @override
  State<MatchingListInvitationsScreen> createState() =>
      _MatchingListInvitationsScreenState();
}

class _MatchingListInvitationsScreenState
    extends State<MatchingListInvitationsScreen> {
  final InvitationService invitationService = InvitationService();

  List<dynamic> users = [];

  String uniqueId = "";
  bool isLoading = true;

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    uniqueId = prefs.getString('onboarding_done') ?? "";
    final response = await invitationService.getAllInvitations(uniqueId);
    print("response init invitation");
    print(response);
    setState(() {
      users = response;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => init());
  }

  void updateInvitation(dynamic cursor, String status) async {
    dynamic response = await invitationService.updateInvitation(
      cursor["invitation_id"],
      MachingGuestInput(guest_id: cursor["guest_id"], status: status),
    );

    bool checkStatus = response.length == 36;

    toastNotification(
      context,
      (checkStatus)
          ? (status == "ACCEPTED")
              ? "Invitation acceptée 💌"
              : "Invitation rejetée 💌"
          : "Echec d'envoie",
    );

    if (checkStatus) {
      setState(() {
        users.remove(cursor);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Vos matchs")),
      body: Center(
        child:
            isLoading
                ? CircularProgressIndicator()
                : users.length == 0
                ? EmptyList(message: "Vous n'avez aucune invitation")
                : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final cursor = users[index];
                    final user =
                        uniqueId != cursor["user_id"]
                            ? cursor["user_info"]
                            : cursor["guest_info"];
                    return GestureDetector(
                      onTap: () => showUserDetailModal(context, cursor),
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text("${user['name']} - ${user['age']} ans"),
                          subtitle: Text(
                            "Ville : ${user['city']} • Compatibilité : ${cursor['compatibility_score']}%",
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  updateInvitation(cursor, "REFUSED");
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.greenAccent,
                                ),
                                onPressed: () async {
                                  updateInvitation(cursor, "ACCEPTED");
                                },
                              ),
                            ],
                          ),

                          // ElevatedButton(
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder:
                          //             (context) =>
                          //                 MatchingChatScreen(userName: user['name']),
                          //       ),
                          //     );
                          //   },
                          //   child: const Text("Discuter"),
                          // ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
