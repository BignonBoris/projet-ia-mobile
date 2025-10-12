import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:projet_ia/components/message.dart';
import 'menu.dart';
import 'package:projet_ia/components/typing.dart';
import '../services/ia_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_id_provider.dart';
import '../providers/settings_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final IAService iaService = IAService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  String responseText = "";

  // Liste des messages
  List<Map<String, String>> messages = [];
  bool isLoading = true;
  bool responseTyping = false;

  // String uniqueId = Uuid().v4();

  void init() async {
    final String uniqueId = context.read<UserIdProvider>().userId;
    print("uniqueId = $uniqueId");
    final response = await iaService.overview(uniqueId);
    print("Réponse API : $response"); // 👈 log dans la console
    setState(() {
      messages = response.toList();
      isLoading = response.isNotEmpty ? false : true;
    });
    // 🔥 Rendre le champ actif immédiatement
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  void initState() {
    super.initState();

    // Ton code "comme dans useEffect([])"
    Future.microtask(() => init());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatMessage(msg) {
    String prefixe = "";
    if (msg['role'] == "user") prefixe = "Vous";
    if (msg['role'] == "assistant") prefixe = "IA";
    return "**$prefixe :** " + msg['content'];
  }

  void sendMessage() async {
    final String uniqueId = context.read<UserIdProvider>().userId;
    final message = _controller.text;
    setState(() {
      messages.add({"role": "user", "content": message});
      responseTyping = true;
    });
    // Scroll vers le bas (si tu as un ScrollController)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    _controller.clear();
    final response = await iaService.sendMessage(uniqueId, message);
    setState(() {
      // responseText = message;
      responseTyping = false;
      messages.add({"role": "assistant", "content": response});
    });

    // 🔥 Rendre le champ actif immédiatement
    FocusScope.of(context).requestFocus(_focusNode);
    // Scroll vers le bas (si tu as un ScrollController)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink, // Couleur de fond
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        title: const Text(
          "Coach de vie",
          style: TextStyle(
            color: Colors.white, // Texte rose
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false, // Centre le texte
        iconTheme: const IconThemeData(color: Colors.white), // Icônes roses
      ),
      drawer: const Menu(),
      backgroundColor: Colors.grey[200], // Fond gris clair du body
      body: Center(
        child:
            isLoading
                ? const CircularProgressIndicator()
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Zone de messages
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ...messages.map((msg) {
                                bool isNotUser = msg['role'] != "user";

                                return Message(
                                  message: msg['content']!,
                                  role: msg['role']!,
                                );

                                // Align(
                                //   alignment:
                                //       isNotUser
                                //           ? Alignment.centerLeft
                                //           : Alignment.centerRight,
                                //   child: Container(
                                //     margin: const EdgeInsets.symmetric(
                                //       vertical: 4,
                                //     ),
                                //     padding: const EdgeInsets.all(12),
                                //     decoration: BoxDecoration(
                                //       color:
                                //           isNotUser
                                //               ? settingsProvider
                                //                   .aiMessageBgColor
                                //               : settingsProvider
                                //                   .userMessageBgColor,
                                //       borderRadius: BorderRadius.only(
                                //         topLeft: const Radius.circular(12),
                                //         topRight: const Radius.circular(12),
                                //         bottomLeft:
                                //             isNotUser
                                //                 ? const Radius.circular(0)
                                //                 : const Radius.circular(12),
                                //         bottomRight:
                                //             isNotUser
                                //                 ? const Radius.circular(12)
                                //                 : const Radius.circular(0),
                                //       ),
                                //       // border: Border.all(
                                //       //   color: Colors.pink,
                                //       //   width: 2,
                                //       // ),
                                //     ),
                                //     child: MarkdownBody(
                                //       data: msg['content'] ?? "",
                                //       styleSheet: MarkdownStyleSheet.fromTheme(
                                //         Theme.of(context),
                                //       ).copyWith(
                                //         p: TextStyle(
                                //           fontSize: 14,
                                //           color:
                                //               isNotUser
                                //                   ? settingsProvider
                                //                       .aiMessageColor
                                //                   : settingsProvider
                                //                       .userMessageColor, // 👈 couleur choisie dans paramètres
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ); // safe fallback
                              }).toList(),
                              if (responseTyping) const TypingLoader(),
                            ],
                          ),
                        ),
                      ),

                      // Champ d’écriture
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode, // 👈 FocusNode ici
                        onSubmitted: (value) {
                          sendMessage(); // Appelle ta fonction d’envoi
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: sendMessage,
                          ),
                          filled: true, // Active le fond
                          fillColor: Colors.white, // Fond blanc
                          labelText: "Votre message",
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
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
