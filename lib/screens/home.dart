import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:projet_ia/data/menu.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:projet_ia/components/menu_bottom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:projet_ia/services/users.dart";
import "package:projet_ia/providers/user_provider.dart";
import "package:projet_ia/classes/user.dart";
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:projet_ia/screens/profile/menu.dart";

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';
import "package:projet_ia/screens/matching/incoming_call_screen.dart";

class HomeScreen extends StatefulWidget {
  int selectedIndex = 2;

  HomeScreen({super.key, this.selectedIndex = 2});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  UserService userService = UserService();
  UserProvider userProvider = UserProvider();
  UserModel? user;
  String _message = "Aucune notification reçue";
  String? userId = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void init() async {
    setState(() {
      _selectedIndex = widget.selectedIndex;
    });
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('onboarding_done');
    print({userId});
    if (userId!.length == 36) {
      user = await userService.getUser(userId!);
      print({user});
      if (user != null) {
        await userProvider.setUserToProvider(user);
        _initFCM();
        _initZego();
      }
    }
  }

  void initState() {
    super.initState();
    init();
  }

  void _initZego() async {
    final int myAppID = 1977886184; // 🧠 ton AppID Zego
    final String myAppSign =
        "42d0d6b58922da0110ec158e17cfa9e3e8e0e072ace8e8842a017ce6111e3aaa";

    /// Initialiser le service d’appel ZegoCloud
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: myAppID,
      appSign: myAppSign,
      userID: userId!, // ton identifiant utilisateur unique
      userName: user!.pseudo ?? user!.name ?? Uuid().v4(),
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  Future<void> _initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Demande la permission à l'utilisateur
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false, // true = silencieux (pas de popup)
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("🔔 Notifications autorisées")),
      // );
      print("🔔 Notifications autorisées");
      final prefs = await SharedPreferences.getInstance();
      // Récupère le token du mobile
      String? token = await messaging.getToken();
      await prefs.setString('fcmToken', token ?? "");
      // user = await userService.getUser(userId!);
      print({token});
      user!.fcmToken = token;

      userProvider.setUserToProvider(user);

      await userService.updateUser(userId!, user!);
    }

    // Gestion des notifications reçues en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📨 Message reçu en foreground: ${message.notification?.title}");
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder:
              (_) => IncomingCallScreen(
                callId: "callId",
                callerName: "callerName",
              ),
        ),
      );
      setState(() {
        _message =
            "Message reçu : ${message.notification?.title} - ${message.notification?.body}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink, // Couleur de fond
        title: Text(
          menus[_selectedIndex]["title"] ?? "Coach",
          style: const TextStyle(
            color: Colors.white, // Texte rose
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: menus[_selectedIndex]["actions"](context),
        centerTitle: false, // Centre le texte
        iconTheme: const IconThemeData(color: Colors.white), // Icônes roses
      ),
      // drawer: const Menu(),
      backgroundColor: Colors.grey[100], // Fond gris clair du body
      body: menus[_selectedIndex]["widget"],
      // endDrawer:
      //     _selectedIndex == 3
      //         ? const ProfileDrawer()
      //         : null, // ✅ ton composant réutilisé
      bottomNavigationBar: MenuBottom(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
