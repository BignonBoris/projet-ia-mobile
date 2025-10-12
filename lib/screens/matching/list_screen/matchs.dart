import 'package:flutter/material.dart';
import 'package:projet_ia/services/matching.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/models/maching_guest_input.dart';
import 'package:projet_ia/components/empty_list.dart';
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
    print("response");
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
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text("${user['name']} - ${user['age']} ans"),
                        subtitle: Text(
                          "Ville : ${user['city']} • Compatibilité : ${matching_result['compatibility_score']}%",
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.blueAccent,
                              ),
                              onPressed:
                                  () => showUserDetailModal(context, cursor),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.person_add_alt_outlined,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () async {
                                String invitation_id = await iaMatchingService
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Invitation envoyée 💌"),
                                  ),
                                );
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
                    );
                  },
                ),
      ),
    );
  }
}
