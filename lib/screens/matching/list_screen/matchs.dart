import 'package:flutter/material.dart';
import 'package:projet_ia/services/matching.dart';
import 'package:projet_ia/services/invitation.dart';
import "package:provider/provider.dart";
import 'package:projet_ia/classes/maching_guest_input.dart';
import 'package:projet_ia/components/empty_list.dart';
import 'package:projet_ia/components/toast.dart';
// import './chat.dart';
import "package:projet_ia/components/matching/show_details.dart";
import "package:projet_ia/providers/invitation_provider.dart";
import "package:projet_ia/utils.dart";
import "package:projet_ia/components/matching/userItem.dart";
import "package:projet_ia/constants/values.dart";

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
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  final int _limit = 100; // nombre d’éléments par page
  bool _hasMore = true;

  List<dynamic> users = [];

  String? userId = "";
  bool isLoading = true;

  // Simulation d’un appel API (tu peux mettre ton API FastAPI ici)
  Future<void> _fetchItems() async {
    userId = await getPrefUserId();
    final response = await iaMatchingService.searchMatching(
      userId!,
      page: _page,
      limit: _limit,
    );

    // si moins que le limit → plus de data
    if (response.length == 0) {
      setState(() {
        _hasMore = false;
      });
    }

    setState(() {
      users.addAll(response);
      _page++;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetchItems());
    // Détection de la fin du scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          _hasMore) {
        _fetchItems();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                : RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      users.clear();
                      _page = 1;
                      _hasMore = true;
                      isLoading = true;
                    });
                    await _fetchItems();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: users.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < users.length) {
                        final cursor = users[index];
                        final user = cursor["user"];
                        final matching_result = cursor["result"];
                        final age =
                            user['dateOfBirth'] != null
                                ? "${calculateAge(user['dateOfBirth'])} ans"
                                : "Non renseigné";
                        return UserItem(
                          user: user,
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.person_add_alt_outlined,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () async {
                                String invitation_id = await InvitationService()
                                    .sendInvitation(
                                      userId!,
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
                                  final invitationProvider =
                                      context.read<InvitationProvider>();
                                  toastNotification(
                                    context,
                                    "Invitation envoyée 💌",
                                  );
                                  invitationProvider.setCount(
                                    invitationProvider.count + 1,
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
                        //         "${user['name']}",
                        //         style: TextStyle(fontWeight: FontWeight.bold),
                        //       ),
                        //       subtitle: Text(
                        //         "${age} • ${user['country'] ?? 'Non renseigné'} • ${user['sexe'] ?? 'Non renseigné'} ",
                        //       ),

                        //       // subtitle: Text(
                        //       //   "Pays : ${user['country'] ?? 'Non renseigné'} • Compatibilité : ${matching_result['compatibility_score'] ?? "0"}%",
                        //       // ),
                        //       trailing: Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           // IconButton(
                        //           //   icon: const Icon(
                        //           //     Icons.remove_red_eye_outlined,
                        //           //     color: Colors.blueAccent,
                        //           //   ),
                        //           //   onPressed:
                        //           //       () => showUserDetailModal(context, cursor),
                        //           // ),
                        //           IconButton(
                        //             icon: const Icon(
                        //               Icons.person_add_alt_outlined,
                        //               color: Colors.blueAccent,
                        //             ),
                        //             onPressed: () async {
                        //               String
                        //               invitation_id = await invitationService
                        //                   .sendInvitation(
                        //                     userId,
                        //                     MachingGuestInput(
                        //                       guest_id: user["user_id"],
                        //                       guest_resume: user["resume"],
                        //                       compatibility_score:
                        //                           matching_result['compatibility_score'],
                        //                       reason: matching_result["reason"],
                        //                       advice: matching_result["advice"],
                        //                     ),
                        //                   );
                        //               if (invitation_id.isNotEmpty) {
                        //                 toastNotification(
                        //                   context,
                        //                   "Invitation envoyée 💌",
                        //                 );
                        //                 setState(() {
                        //                   users.remove(cursor);
                        //                 });
                        //               } else {
                        //                 toastNotification(
                        //                   context,
                        //                   "Echec d'envoie d'invitation, veuiller réssayer svp",
                        //                 );
                        //               }
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
                      } else {
                        // Loader à la fin
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
      ),
    );
  }
}
