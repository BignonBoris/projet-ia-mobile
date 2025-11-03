import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:projet_ia/screens/home.dart';
import 'providers/user_id_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/user_provider.dart';
import 'providers/menu_provider.dart';
import 'package:projet_ia/screens/on_bording.dart';
import "package:projet_ia/services/users.dart";
import "package:projet_ia/classes/user.dart";

// Fonction appelée quand une notification arrive en background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("📩 Message reçu en background: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  UserService userService = UserService();
  UserModel user = UserModel();
  // String _message = "Aucune notification reçue";

  @override
  void initState() {
    super.initState();
    // _initFCM();
  }

  // Future<void> _initFCM() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;

  //   // Demande la permission à l'utilisateur
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print("🔔 Notifications autorisées");
  //     final prefs = await SharedPreferences.getInstance();

  //     // Récupère le token du mobile
  //     String? token = await messaging.getToken();
  //     await prefs.setString('fcmToken', token ?? "");
  //     print(token);
  //     // ✅ Envoie le token au backend FastAPI
  //     // await await http.post(
  //     //   Uri.parse("$baseUrl/register_device"),
  //     //   headers: {"Content-Type": "application/json"},
  //     //   body: jsonEncode({"token": token, "platform": "mobile"}),
  //     // );
  //   }

  //   // Gestion des notifications reçues en foreground
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print("📨 Message reçu en foreground: ${message.notification?.title}");
  //     setState(() {
  //       _message =
  //           "Message reçu : ${message.notification?.title} - ${message.notification?.body}";
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home:
          (widget.seenOnboarding.length == 36)
              ? HomeScreen()
              : OnboardingScreen(),
    );
  }
}
