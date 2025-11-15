import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:projet_ia/services/connexion.dart';
import 'package:projet_ia/components/empty_list.dart';
import 'package:projet_ia/screens/matching/chat.dart';
import 'package:projet_ia/components/unread_message.dart';
import "package:projet_ia/constants/values.dart";
// import 'package:projet_ia/constants/url.dart';
import 'package:projet_ia/providers/connexion_provider.dart';
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
  late IO.Socket socket;
  final ConnexionService connexionService = ConnexionService();

  List<dynamic> users = [];

  String? userId = "";
  bool isLoading = true;

  void init() async {
    final connexionProvider = context.read<ConnexionProvider>();
    List<dynamic> response = [];
    userId = await getPrefUserId();
    print("pref = $userId");
    response = await connexionService.getAllUserConnexions(userId!);
    connexionProvider.setConnexions(response);
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
    final connexionProvider = context.watch<ConnexionProvider>();

    return Center(
      child:
          isLoading
              ? CircularProgressIndicator()
              : connexionProvider.connexions.length == 0
              ? EmptyList(message: "Vous n'avez aucun message")
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
                      cursor["user_id"] == userId
                          ? cursor["guest_info"]
                          : cursor["user_info"];

                  final profileImagePath =
                      user["profileImagePath"] != null
                          ? user["profileImagePath"]
                          : user["imageProfile"] != null
                          ? user["imageProfile"]
                          : user["user_info"] != null &&
                              user["user_info"]![0] != null &&
                              user["user_info"]![0]!["imageProfile"] != null
                          ? user["user_info"]![0]!["imageProfile"]
                          : "";

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MatchingChatScreen(
                                connexion: cursor,
                                user: user,
                                user_id: userId!,
                              ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading:
                            profileImagePath == ""
                                ? const CircleAvatar(child: Icon(Icons.person))
                                : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    profileImagePath,
                                  ),
                                ),
                        // leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(
                          "${user['pseudo']}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
    );
  }
}
