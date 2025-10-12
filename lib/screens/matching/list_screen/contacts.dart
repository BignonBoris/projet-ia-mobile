import 'package:flutter/material.dart';
import 'package:projet_ia/services/connexion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/components/empty_list.dart';
import 'package:projet_ia/screens/matching/chat.dart';
import 'package:projet_ia/components/unread_message.dart';
// import './chat.dart';

//
// 3️⃣ LIST SCREEN
//

class MatchingListContactsScreen extends StatefulWidget {
  const MatchingListContactsScreen({super.key});

  @override
  State<MatchingListContactsScreen> createState() =>
      _MatchingListContactsScreenState();
}

class _MatchingListContactsScreenState
    extends State<MatchingListContactsScreen> {
  final ConnexionService connexionService = ConnexionService();

  List<dynamic> users = [];

  String uniqueId = "";
  bool isLoading = false;

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    uniqueId = prefs.getString('onboarding_done') ?? "";
    final response = await connexionService.getAllUserConnexions(uniqueId);
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
                ? EmptyList(message: "Vous avez aucun message")
                : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final cursor = users[index];
                    String lastMessage =
                        cursor["messages"].isNotEmpty
                            ? cursor["messages"][cursor["messages"].length -
                                1]["message"]
                            : "";
                    final user =
                        cursor["user_id"] == uniqueId
                            ? cursor["guest_info"]
                            : cursor["user_info"];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MatchingChatScreen(
                                  connexion: cursor,
                                  user: user,
                                  user_id: uniqueId,
                                ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text("${user['name']} "),
                          subtitle: Text(
                            lastMessage,
                            maxLines: 1, // Limite le texte à une seule ligne
                            overflow:
                                TextOverflow
                                    .ellipsis, // Affiche des points de suspension si le texte dépasse
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: IconButton(
                                  onPressed: () {
                                    // Aller à la page de messages
                                  },
                                  icon: SimpleBadge(count: 4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
