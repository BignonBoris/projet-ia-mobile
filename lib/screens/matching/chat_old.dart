import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:projet_ia/services/connexion.dart';

//
// 4️⃣ CHAT SCREEN
//
class MatchingChatScreen extends StatefulWidget {
  final String userName;
  final String connexion_id;
  final String user_id;

  const MatchingChatScreen({
    super.key,
    required this.userName,
    required this.connexion_id,
    required String this.user_id,
  });

  @override
  State<MatchingChatScreen> createState() => _MatchingChatScreenState();
}

class _MatchingChatScreenState extends State<MatchingChatScreen> {
  late IO.Socket socket;
  final ConnexionService connexionService = ConnexionService();
  final List<String> messages = ["Salut 👋", "Comment vas-tu ?"];
  final TextEditingController controller = TextEditingController();

  void initState() {
    super.initState();
    _connectSocket();
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

    socket.onConnect((_) {
      setState(() {
        messages.add("✅ Connecté au serveur Socket.IO");
      });
    });

    socket.onDisconnect((_) {
      setState(() {
        messages.add("❌ Déconnecté du serveur");
      });
    });

    socket.on("server_to_client", (data) {
      print(data);
      setState(() {
        messages.add("📩 Serveur : $data");
      });
    });
  }

  void sendMessage() async {
    if (controller.text.trim().isNotEmpty) {
      final message = controller.text.trim();
      dynamic data = {"message": message, "user_id": "10"};
      socket.emit("client_to_server", data);

      setState(() {
        messages.add(message);
      });

      final response = await connexionService.sendMessage(
        widget.connexion_id,
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
      appBar: AppBar(title: Text("Chat avec ${widget.userName}")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment:
                      index % 2 == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          index % 2 == 0
                              ? Colors.grey.shade300
                              : Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(messages[index]),
                  ),
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
