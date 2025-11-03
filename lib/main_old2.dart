import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projet_ia/screens/home.dart';
import 'package:provider/provider.dart';
import 'providers/user_id_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/user_provider.dart';
import 'providers/menu_provider.dart';
// import 'screens/welcom_chat.dart';
import 'package:projet_ia/screens/on_bording.dart';
import "package:projet_ia/constants/url.dart";

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("📦 Message reçu en arrière-plan: ${message.messageId}");
// }

// Fonction appelée quand une notification arrive en background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("📩 Message reçu en background: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //     apiKey:
  //         "AIzaSyA-7zpJrb1Ngo7KB0g155u_PWKJC7fw_-o", // <-- Remplace avec ton apiKey
  //     appId: "1:1057982567529:web:6d5dd88bf367489aaa3ef8",
  //     messagingSenderId: "1057982567529",
  //     projectId: "helper-92613",
  //   ),
  // );
  // // Gestion des messages en arrière-plan
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getString('onboarding_done') ?? "";

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => UserIdProvider()..generateId()),
        ChangeNotifierProvider(create: (_) => UserIdProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // ChangeNotifierProvider(create: (_) => UserIdProvider()..loadUserId()),
      ],
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String seenOnboarding;
  @override
  State<MyApp> createState() => _MyAppState();
  MyApp({super.key, required this.seenOnboarding});
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String? _token;
  String _message = "Aucune notification reçue";

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  // Future<void> _initFCM() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;

  //   // Demande de permission sur iOS
  //   await messaging.requestPermission();

  //   // Récupère le token FCM (à envoyer à ton backend)
  //   _token = await messaging.getToken(
  //     vapidKey:
  //         "BHYlj3AEbLHQF_TExDryzYf8-aQscE-DdYISXJ6JIk7x3eMDCGOhsQdxffSGqjCrJTbPcNB48ENW5luRZEnxXus",
  //   );
  //   print("📱 FCM Token: $_token");

  //   // Écoute les messages reçus quand l’app est ouverte
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('🔔 Message reçu : ${message.notification?.title}');
  //     setState(() {
  //       _message = message.notification?.title ?? "Notification reçue";
  //     });
  //   });
  // }

  Future<void> _initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Demande la permission à l'utilisateur
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("🔔 Notifications autorisées");

      // Récupère le token du mobile
      String? token = await messaging.getToken();
      setState(() {
        _token = token;
      });
      print("🔥 Token mobile: $token");

      // ✅ Envoie le token au backend FastAPI
      await http.post(
        Uri.parse("$baseUrl/register_device"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token, "platform": "mobile"}),
      );
    }

    // Gestion des notifications reçues en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📨 Message reçu en foreground: ${message.notification?.title}");
      setState(() {
        _message =
            "Message reçu : ${message.notification?.title} - ${message.notification?.body}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(title: Text("Test FCM")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "FCM Token :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText(_token ?? "Chargement..."),
              const SizedBox(height: 20),
              Text(
                "Dernier message :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(_message),
            ],
          ),
        ),
      ),
      // home:
      //     (this.seenOnboarding.length == 36)
      //         ? HomeScreen()
      //         : OnboardingScreen(),
    );
  }
}
