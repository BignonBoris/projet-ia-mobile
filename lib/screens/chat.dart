import 'package:flutter/material.dart';
import 'package:projet_ia/components/message.dart';
import 'package:projet_ia/components/typing.dart';
import 'package:projet_ia/components/reloadAction.dart';
import 'package:projet_ia/data/error.dart';
import 'package:projet_ia/services/ia_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/utils.dart';
import 'package:projet_ia/components/start.dart';
import 'package:projet_ia/constants/texts.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final IAService iaService = IAService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  String uniqueId = "";

  // Liste des messages
  List<Map<String, String>> messages = [];
  bool showReloadAction = false;
  bool isLoading = true;
  bool responseTyping = false;

  void getMessages() async {
    // final String uniqueId = context.read<UserIdProvider>().userId;

    final prefs = await SharedPreferences.getInstance();
    uniqueId = prefs.getString('onboarding_done') ?? "";

    print("uniqueId = $uniqueId");
    final response = await iaService.getUserMessages(uniqueId);
    print("Réponse API : $response"); // 👈 log dans la console
    setState(() {
      messages = response.toList();
      isLoading = false;
    });

    if (response.isNotEmpty) {
      // Scroll vers le bas (si tu as un ScrollController)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
      // 🔥 Rendre le champ actif immédiatement
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  void initState() {
    super.initState();

    // Ton code "comme dans useEffect([])"
    Future.microtask(() => getMessages());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void initMessage() async {
    setState(() {
      isLoading = true;
    });

    final response = await iaService.initUserMessages(uniqueId);
    print("Réponse API : $response"); // 👈 log dans la console

    setState(() {
      messages = response.toList();
      isLoading = false;
    });
  }

  void sendMessage() async {
    // final String uniqueId = context.read<UserIdProvider>().userId;
    final message = _messageController.text;
    setState(() {
      messages.add({"role": "user", "content": message});
      responseTyping = true;
      showReloadAction = false;
    });
    // Scroll vers le bas (si tu as un ScrollController)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    _messageController.clear();
    final response = await iaService.sendMessage(uniqueId, message);
    if (response != Error500) {
      setState(() {
        responseTyping = false;
        messages.add({"role": "assistant", "content": response});
      });
    } else {
      setState(() {
        responseTyping = false;
        showReloadAction = true;
      });
    }

    // 🔥 Rendre le champ actif immédiatement
    FocusScope.of(context).requestFocus(_focusNode);
    // Scroll vers le bas (si tu as un ScrollController)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void callReloadAction(String value) {
    if (value.length > 0) {
      setState(() {
        messages.add({"role": "assistant", "content": value});
        showReloadAction = false;
      });
    }
    // Scroll vers le bas (si tu as un ScrollController)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = introTexts["coach"]!;
    return Center(
      child:
          isLoading
              ? const CircularProgressIndicator()
              : Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                    messages.length == 0
                        ? StartScreen(
                          startAction: () => initMessage(),
                          icon: Icons.chat_bubble_outline,
                          title: data["title"]!,
                          description: data["description"]!,
                          // "Je suis ravi de t'accueillir cette espace intime d'échange ! Je suis avec votre conseillé en relation sentimental.\n Appuyez sur le bouton ci-dessous pour commencer.",
                        )
                        : Column(
                          children: [
                            // Zone de messages
                            Expanded(
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ...messages
                                        .where(
                                          (msg) =>
                                              msg["content"] != null &&
                                              msg["content"]!.isNotEmpty,
                                        )
                                        .map((msg) {
                                          return Message(
                                            message: msg['content']!,
                                            role: msg['role']!,
                                          );
                                        })
                                        .toList(),
                                    if (responseTyping) const TypingLoader(),
                                    if (showReloadAction)
                                      ReloadAction(
                                        onReloadAction: callReloadAction,
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            // Champ d’écriture
                            TextField(
                              controller: _messageController,
                              onChanged:
                                  (value) => formattedInputText(
                                    value,
                                    _messageController,
                                  ),
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
    );
  }
}
