import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:projet_ia/services/connexion.dart';
import 'package:projet_ia/components/message.dart';

//
// 4️⃣ CHAT SCREEN
//
class MatchingChatScreen extends StatefulWidget {
  final dynamic connexion; // les information de la connexion
  final dynamic user; // les information de l'autre utilisateur
  final String user_id; // l'id de l'utilisateur connecté

  const MatchingChatScreen({
    super.key,
    required this.connexion,
    required this.user,
    required this.user_id,
  });

  @override
  State<MatchingChatScreen> createState() => _MatchingChatScreenState();
}

class _MatchingChatScreenState extends State<MatchingChatScreen> {
  late IO.Socket socket;
  final ConnexionService connexionService = ConnexionService();
  // final List<String> messages = ["Salut 👋", "Comment vas-tu ?"];
  List<dynamic> messages = [];
  final TextEditingController controller = TextEditingController();

  void initState() {
    super.initState();
    _connectSocket();
    messages = widget.connexion["messages"];
  }

  void _connectSocket() {
    socket = IO.io(
      'http://localhost:8000', // 👉 remplace par ton URL socket (ex: http://192.168.x.x:8000)
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    String IOClientOn = widget.connexion['connexion_id'];

    socket.onConnect((_) {
      print("✅ Connecté au serveur Socket.IO");
      // setState(() {
      //   messages.add("✅ Connecté au serveur Socket.IO");
      // });
    });

    socket.onDisconnect((_) {
      print("❌ Déconnecté du serveur");
      // setState(() {
      //   messages.add("❌ Déconnecté du serveur");
      // });
    });

    socket.on("server_to_client_#$IOClientOn", (data) {
      print(data);
      setState(() {
        messages.add(data);
      });
    });
  }

  void sendMessage() async {
    if (controller.text.trim().isNotEmpty) {
      String message = controller.text.trim();
      message = message[0].toUpperCase() + message.substring(1);

      dynamic data = {
        "message": message,
        "connexion_id": widget.connexion["connexion_id"],
      };
      socket.emit("client_to_server", data);

      setState(() {
        messages.add({"user_id": widget.user_id, "message": message});
      });

      final response = await connexionService.sendMessage(
        widget.connexion["connexion_id"],
        widget.user_id,
        message,
      );

      print(response);

      controller.clear();
    }
  }

  void dispose() {
    socket.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat avec ${widget.user["name"]}")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                dynamic message = messages[index];
                return Message(
                  message: message['message']!,
                  role:
                      message['user_id'] == widget.user_id
                          ? "user"
                          : message['user_id'] == "system"
                          ? "system"
                          : "assistance",
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,

                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: sendMessage,
                      ),
                      filled: true, // Active le fond
                      fillColor: Colors.white, // Fond blanc
                      labelText: "Votre message",
                      hintText: "Écrire un message...",
                      labelStyle: const TextStyle(color: Colors.pink),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.pink,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.pink,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // decoration: const InputDecoration(
                    //   hintText: "Écrire un message...",
                    //   border: OutlineInputBorder(),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
