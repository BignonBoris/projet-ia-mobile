import 'package:flutter/material.dart';
import 'package:projet_ia/components/message.dart';
import 'package:projet_ia/components/typing.dart';
import 'package:projet_ia/data/error.dart';
import 'package:projet_ia/services/matching.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/utils.dart';

//
// 2️⃣ FORM SCREEN
//
class MatchingFormScreen extends StatefulWidget {
  @override
  State<MatchingFormScreen> createState() => _MatchingFormScreenState();
}

class _MatchingFormScreenState extends State<MatchingFormScreen> {
  final IAMatchingService iaMatchingService = IAMatchingService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  String uniqueId = "";

  // Liste des messages
  List<Map<String, String>> messages = [];
  bool showReloadAction = false;
  bool isLoading = true;
  bool responseTyping = false;

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    uniqueId = prefs.getString('onboarding_done') ?? "";
    final response = await iaMatchingService.initMatching(uniqueId);
    setState(() {
      messages.add({"role": "assistant", "content": response});
      isLoading = response.isNotEmpty ? false : true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => init());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void sendMessage() async {
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
    final response = await iaMatchingService.sendMessage(uniqueId, message);
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

  Widget build(BuildContext context) {
    return Center(
      child:
          isLoading
              ? const CircularProgressIndicator()
              : Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          ],
                        ),
                      ),
                    ),

                    // Champ d’écriture
                    TextField(
                      controller: _messageController,
                      onChanged:
                          (value) =>
                              formattedInputText(value, _messageController),
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
