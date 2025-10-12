import 'package:flutter/material.dart';
import 'package:projet_ia/services/matching.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/components/empty_list.dart';
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
  final IAMatchingService iaMatchingService = IAMatchingService();

  List<dynamic> users = [];

  String uniqueId = "";
  bool isLoading = true;

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    uniqueId = prefs.getString('onboarding_done') ?? "";
    final response = await iaMatchingService.getAllInvitations(uniqueId);
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
                    print("cursor");
                    print(cursor);
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
                                onPressed:
                                    () => showUserDetailModal(context, cursor),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Invitation annullé 💌"),
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
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
