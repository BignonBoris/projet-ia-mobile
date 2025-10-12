import 'package:flutter/material.dart';
import 'package:projet_ia/screens/home.dart';
import 'package:provider/provider.dart';
import 'providers/user_id_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/menu_provider.dart';
// import 'screens/welcom_chat.dart';
import 'package:projet_ia/screens/on_bording.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getString('onboarding_done') ?? "";

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => UserIdProvider()..generateId()),
        ChangeNotifierProvider(create: (_) => UserIdProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        // ChangeNotifierProvider(create: (_) => UserIdProvider()..loadUserId()),
      ],
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String seenOnboarding;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home:
          (this.seenOnboarding.length == 36)
              ? HomeScreen()
              : OnboardingScreen(),
    );
  }
}

// class ChatScreen extends StatefulWidget {
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final IAService iaService = IAService();
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   String responseText = "";

//   // Liste des messages
//   List<Map<String, String>> messages = [];
//   String uniqueId = Uuid().v4();

//   void init() async {
//     final response = await iaService.overview(uniqueId);
//     print("Réponse API : $response"); // 👈 log dans la console
//     setState(() {
//       messages = response.toList();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Ton code "comme dans useEffect([])"
//     init();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   String formatMessage(msg) {
//     String prefixe = msg['role'] == "user" ? "Vous" : "IA";
//     return "**$prefixe :** " + msg['content'];
//   }

//   void sendMessage() async {
//     final message = _controller.text;
//     setState(() {
//       messages.add({"role": "user", "content": message});
//     });
//     _controller.clear();
//     final response = await iaService.sendMessage(uniqueId, message);
//     setState(() {
//       responseText = message;
//       messages.add({"role": "assistant", "content": response});
//     });
//     // Scroll vers le bas (si tu as un ScrollController)
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.pink, // Couleur de fond
//         leading: Builder(
//           builder:
//               (context) => IconButton(
//                 icon: const Icon(Icons.menu),
//                 onPressed: () {
//                   Scaffold.of(context).openDrawer();
//                 },
//               ),
//         ),
//         title: const Text(
//           "Coach de vie",
//           style: TextStyle(
//             color: Colors.white, // Texte rose
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: false, // Centre le texte
//         iconTheme: const IconThemeData(color: Colors.white), // Icônes roses
//       ),
//       drawer: const Menu(), // ✅ Utilisation du menu importé,
//       backgroundColor: Colors.grey[200], // Fond gris clair du body
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Zone de messages
//             Expanded(
//               child: SingleChildScrollView(
//                 controller: _scrollController,
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children:
//                       messages.map((msg) {
//                         return Container(
//                           margin: const EdgeInsets.symmetric(vertical: 4),
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.pink, width: 2),
//                           ),
//                           child: MarkdownBody(
//                             data: formatMessage(msg) ?? "",
//                             styleSheet: MarkdownStyleSheet.fromTheme(
//                               Theme.of(context),
//                             ).copyWith(p: const TextStyle(fontSize: 14)),
//                           ),
//                         ); // safe fallback
//                       }).toList(),
//                 ),
//               ),
//             ),

//             // Champ d’écriture
//             TextField(
//               controller: _controller,
//               onSubmitted: (value) {
//                 sendMessage(); // Appelle ta fonction d’envoi
//               },
//               decoration: InputDecoration(
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: sendMessage,
//                 ),
//                 filled: true, // Active le fond
//                 fillColor: Colors.white, // Fond blanc
//                 labelText: "Votre message",
//                 labelStyle: const TextStyle(color: Colors.pink),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Colors.pink, width: 2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Colors.pink, width: 2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
