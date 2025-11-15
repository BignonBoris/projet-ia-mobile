import 'package:flutter/material.dart';
import 'package:projet_ia/services/invitation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/components/empty_list.dart';
import 'package:projet_ia/classes/maching_guest_input.dart';
import 'package:projet_ia/components/toast.dart';
// import './chat.dart';
import "package:projet_ia/components/matching/show_details.dart";
import "package:projet_ia/utils.dart";
import "package:projet_ia/components/matching/userItem.dart";
import "package:projet_ia/constants/values.dart";

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

  String? userId = "";
  bool isLoading = true;

  void init() async {
    userId = await getPrefUserId();
    final response = await invitationService.getAllInvitations(userId!);
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
                        cursor["user_id"] == userId
                            ? cursor["guest_info"]
                            : cursor["user_info"];
                    return UserItem(
                      user: user,
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () async {
                            updateInvitation(cursor, "REFUSED");
                          },
                        ),

                        userId == cursor["guest_info"]
                            ? IconButton(
                              icon: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.greenAccent,
                              ),
                              onPressed: () async {
                                updateInvitation(cursor, "ACCEPTED");
                              },
                            )
                            : Text(""),
                      ],
                    );
                    // GestureDetector(
                    //   onTap: () => showUserDetailModal(context, cursor),
                    //   child: Card(
                    //     margin: const EdgeInsets.all(10),
                    //     child: ListTile(
                    //       leading: const CircleAvatar(
                    //         child: Icon(Icons.person),
                    //       ),
                    //       title: Text(
                    //         "${user['pseudo']} - ${calculateAge(user['dateOfBirth'])} ans",
                    //       ),
                    //       subtitle: Text(
                    //         "${user['country']} • ${user['sexe']} • Compatibilité : ${cursor['compatibility_score']}%",
                    //       ),

                    //       trailing: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           IconButton(
                    //             icon: const Icon(
                    //               Icons.cancel,
                    //               color: Colors.red,
                    //             ),
                    //             onPressed: () async {
                    //               updateInvitation(cursor, "REFUSED");
                    //             },
                    //           ),
                    //           IconButton(
                    //             icon: const Icon(
                    //               Icons.check_circle_outline,
                    //               color: Colors.greenAccent,
                    //             ),
                    //             onPressed: () async {
                    //               updateInvitation(cursor, "ACCEPTED");
                    //             },
                    //           ),
                    //         ],
                    //       ),

                    //       // ElevatedButton(
                    //       //   onPressed: () {
                    //       //     Navigator.push(
                    //       //       context,
                    //       //       MaterialPageRoute(
                    //       //         builder:
                    //       //             (context) =>
                    //       //                 MatchingChatScreen(userName: user['name']),
                    //       //       ),
                    //       //     );
                    //       //   },
                    //       //   child: const Text("Discuter"),
                    //       // ),
                    //     ),
                    //   ),
                    // );
                  },
                ),
      ),
    );
  }
}
