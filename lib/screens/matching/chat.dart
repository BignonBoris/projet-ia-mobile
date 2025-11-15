import 'package:flutter/material.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:projet_ia/services/connexion.dart';
import 'package:projet_ia/services/notification.dart';
import 'package:projet_ia/components/message.dart';
import 'package:projet_ia/constants/url.dart';
import "package:projet_ia/providers/user_provider.dart";
import 'package:projet_ia/providers/connexion_provider.dart';
import "package:projet_ia/components/matching/chat_media_action.dart";
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  final ScrollController _scrollController = ScrollController();
  late IO.Socket socket;
  final ConnexionService connexionService = ConnexionService();
  final NotificationService notificationService = NotificationService();
  // final List<String> messages = ["Salut 👋", "Comment vas-tu ?"];
  List<dynamic> messages = [];
  final TextEditingController controller = TextEditingController();
  UserProvider userProvider = UserProvider();

  final int myAppID = 1977886184; // 🧠 ton AppID Zego
  final String myAppSign =
      "42d0d6b58922da0110ec158e17cfa9e3e8e0e072ace8e8842a017ce6111e3aaa";

  void initState() {
    super.initState();

    // Scroll vers le bas (si tu as un ScrollController)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });

    _connectSocket();
    messages = widget.connexion["messages"];

    // // Initialisation du SDK
    // ZegoUIKit().initLog().then((_) {
    //   ZegoUIKit().init(appID: myAppID, appSign: myAppSign);
    // });

    // // Initialise la partie Signaling (pour appels / invitations)
    // ZegoUIKitSignalingPlugin().init();

    // 👉 Ici, tu actives les listeners
    _initZegoListeners();
  }

  void _initZegoListeners() {
    // // 🔔 Listener pour invitation d’appel
    // ZegoUIKitPrebuiltCallInvitationService().onIncomingCallReceived = (
    //   ZegoCallInvitationData data,
    // ) {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text("📞 Appel entrant")));
    //   // print('📞 Appel entrant de : ${data.inviter?.userName}');
    // };

    // // 📴 Listener quand l’appel est refusé ou terminé
    // ZegoUIKitPrebuiltCallInvitationService().onIncomingCallCanceled = (
    //   ZegoCallInvitationData data,
    // ) {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text("🚫 Appel annulé")));
    //   // print('🚫 Appel annulé');
    // };

    // // ✅ Listener pour savoir si l’utilisateur rejoint un call
    // ZegoUIKit().getSignalingPlugin().onInvitationAccepted = (
    //   ZegoSignalingPluginInvitationAcceptedEvent event,
    // ) {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text("✅ Invitation acceptée")));
    //   // print("✅ Invitation acceptée par : ${event.invitee.id}");
    // };
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

    String IOClientOn = "server_to_client_#${widget.connexion['connexion_id']}";
    String IOClientUpdateConnexionChannel =
        "server_to_client_user_connexion_update#${widget.user_id}";

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

    // socket.onAny((event, data) {
    //   print("📡 Event reçu : $event");
    //   print("📦 Data : $data");
    // });

    socket.on(IOClientOn, (data) {
      print(data);
      setState(() {
        messages.add(data);
      });
    });

    socket.on(IOClientUpdateConnexionChannel, (data) {
      context.read<ConnexionProvider>().setConnexions(data['data']);
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

      // Scroll vers le bas (si tu as un ScrollController)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });

      socket.emit(
        "client_to_server",
        data,
      ); // ICI UN SOCKET POUR INFORMER LE BACKEND DE L'ENVOIE DE MESSAGE

      await connexionService.sendMessage(
        widget.connexion["connexion_id"],
        widget.user_id,
        message,
      );

      print("client_to_server_user_connexion_update");
      socket.emit(
        "client_to_server_user_connexion_update",
        {"user_id": widget.user_id, "guest_id": widget.user["user_id"]},
      ); // ICI UN SOCKET POUR FAIRE UNE DEMANDE DE MISE A JOUR DE LA LISTE DES CONNEXIONS AVEC LES MESSAGES
    }
  }

  void dispose() {
    socket.dispose();
    controller.dispose();
    _scrollController.dispose();
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
              userID: widget.user_id, // "currentUserId",
              userName:
                  "${userProvider.pseudo}(${widget.user_id})", // "currentUserId",
              // callID: _getCallId("currentUserId", "otherUserId"),
              callID: _getCallId(widget.user_id, widget.user["user_id"]),
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
              userID: widget.user_id, // "currentUserId",
              userName:
                  "${userProvider.pseudo}(${widget.user_id})", // "currentUserId",
              callID: _getCallId(widget.user_id, widget.user["user_id"]),
              // callID: _getCallId("currentUserId", "otherUserId"),
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

    final profileImagePath =
        widget.user["profileImagePath"] != null
            ? widget.user["profileImagePath"]
            : widget.user["imageProfile"] != null
            ? widget.user["imageProfile"]
            : widget.user["user_info"] != null &&
                widget.user["user_info"]![0] != null &&
                widget.user["user_info"]![0]!["imageProfile"] != null
            ? widget.user["user_info"]![0]!["imageProfile"]
            : "";

    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              Container(
                child:
                    profileImagePath == ""
                        ? CircleAvatar(child: Icon(Icons.person))
                        : CircleAvatar(
                          backgroundImage: NetworkImage(profileImagePath),
                        ),
              ),
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
            icon: const Icon(Icons.call),
            onPressed: () => _startAudioCall(context),
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () => _startVideoCall(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.pink, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ChatMediaAction(),
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
                            color: Colors.white,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
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
          ),
        ],
      ),
      // floatingActionButton: ChatMediaAction(),
    );
  }
}
