import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:projet_ia/classes/user.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:projet_ia/services/connexion.dart';
import 'package:projet_ia/services/notification.dart';
import 'package:projet_ia/components/message.dart';
import 'package:projet_ia/constants/url.dart';
import "package:projet_ia/classes/notification.dart";
import "package:projet_ia/providers/user_provider.dart";

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
  final NotificationService notificationService = NotificationService();
  // final List<String> messages = ["Salut 👋", "Comment vas-tu ?"];
  List<dynamic> messages = [];
  final TextEditingController controller = TextEditingController();
  UserProvider userProvider = UserProvider();

  void initState() {
    super.initState();
    _connectSocket();
    messages = widget.connexion["messages"];
    print(widget.connexion["messages"]);
  }

  void _connectSocket() {
    socket = IO.io(
      baseUrl,
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
        "user_id": widget.user_id,
        "message": message,
        "connexion_id": widget.connexion["connexion_id"],
      };

      setState(() {
        messages.add({"user_id": widget.user_id, "message": message});
      });
      controller.clear();

      socket.emit("client_to_server", data);

      await connexionService.sendMessage(
        widget.connexion["connexion_id"],
        widget.user_id,
        message,
      );
    }
  }

  void dispose() {
    socket.dispose();
    controller.dispose();
    super.dispose();
  }

  void _startVideoCall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ZegoUIKitPrebuiltCall(
              appID: 1977886184, // 🧠 ton AppID Zego
              appSign:
                  "42d0d6b58922da0110ec158e17cfa9e3e8e0e072ace8e8842a017ce6111e3aaa", // 🧠 ton AppSign Zego
              userID: "currentUserId",
              userName: "currentUserId",
              callID: _getCallId("currentUserId", "otherUserId"),
              config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
            ),
      ),
    );
  }

  void _startAudioCall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ZegoUIKitPrebuiltCall(
              appID: 1977886184,
              appSign:
                  "42d0d6b58922da0110ec158e17cfa9e3e8e0e072ace8e8842a017ce6111e3aaa",
              userID: "currentUserId",
              userName: "currentUserId",
              callID: _getCallId("currentUserId", "otherUserId"),
              config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
            ),
      ),
    );
  }

  String _getCallId(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  @override
  Widget build(BuildContext context) {
    userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              CircleAvatar(child: Icon(Icons.person)),
              SizedBox(width: 10),
              Text(
                "${widget.user["pseudo"]}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () => _startVideoCall(context),
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => _startAudioCall(context),
          ),
        ],
      ),
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
                        onPressed: () => sendMessage(),
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
