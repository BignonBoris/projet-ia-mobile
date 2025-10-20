import 'package:flutter/material.dart';
import 'package:projet_ia/services/matching.dart';
import 'package:projet_ia/services/invitation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/classes/maching_guest_input.dart';
import 'package:projet_ia/components/empty_list.dart';
import 'package:projet_ia/components/toast.dart';
// import './chat.dart';
import "package:projet_ia/components/matching/show_details.dart";

//
// 3️⃣ LIST SCREEN
//

class MatchingListMatchsScreen extends StatefulWidget {
  const MatchingListMatchsScreen({super.key});

  @override
  State<MatchingListMatchsScreen> createState() =>
      _MatchingListMatchsScreenState();
}

class _MatchingListMatchsScreenState extends State<MatchingListMatchsScreen> {
  final IAMatchingService iaMatchingService = IAMatchingService();
  final InvitationService invitationService = InvitationService();

  List<dynamic> users = [
    // {
    //   "user": {"name": "Alice", "age": 25, "city": "Cotonou", "match": 92},
    //   "result": {
    //     "compatibility_score": 50,
    //     "reason": "Il est difficile de déterminer une",
    //   },
    // },
  ];

  String uniqueId = "";
  bool isLoading = true;

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    uniqueId = prefs.getString('onboarding_done') ?? "";
    final response = await iaMatchingService.searchMatching(uniqueId);
    print("response init match");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Vos matchs")),
      body: Center(
        child:
            isLoading
                ? CircularProgressIndicator()
                : users.length == 0
                ? EmptyList()
                : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final cursor = users[index];
                    final user = cursor["user"];
                    final matching_result = cursor["result"];
                    final age =
                        user['age'] != null
                            ? "${user['age']} ans"
                            : "Non renseigné";
                    return GestureDetector(
                      onTap: () => showUserDetailModal(context, cursor),
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            "${user['name'] ?? 'Non renseigné'} - ${age}",
                          ),
                          subtitle: Text(
                            "Ville : ${user['city'] ?? 'Non renseigné'} • Compatibilité : ${matching_result['compatibility_score'] ?? "0"}%",
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // IconButton(
                              //   icon: const Icon(
                              //     Icons.remove_red_eye_outlined,
                              //     color: Colors.blueAccent,
                              //   ),
                              //   onPressed:
                              //       () => showUserDetailModal(context, cursor),
                              // ),
                              IconButton(
                                icon: const Icon(
                                  Icons.person_add_alt_outlined,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () async {
                                  String invitation_id = await invitationService
                                      .sendInvitation(
                                        uniqueId,
                                        MachingGuestInput(
                                          guest_id: user["user_id"],
                                          guest_resume: user["resume"],
                                          compatibility_score:
                                              matching_result['compatibility_score'],
                                          reason: matching_result["reason"],
                                          advice: matching_result["advice"],
                                        ),
                                      );
                                  if (invitation_id.isNotEmpty) {
                                    toastNotification(
                                      context,
                                      "Invitation envoyée 💌",
                                    );
                                    setState(() {
                                      users.remove(cursor);
                                    });
                                  } else {
                                    toastNotification(
                                      context,
                                      "Echec d'envoie d'invitation, veuiller réssayer svp",
                                    );
                                  }
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
