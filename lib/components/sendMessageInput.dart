import 'package:flutter/material.dart';
import 'package:projet_ia/data/error.dart';
import 'package:projet_ia/services/ia_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/utils.dart';

class Sendmessageinput extends StatefulWidget {
  @override
  State<Sendmessageinput> createState() => _SendmessageinputState();
}

class _SendmessageinputState extends State<Sendmessageinput> {
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

  void init() async {
    // final String uniqueId = context.read<UserIdProvider>().userId;

    final prefs = await SharedPreferences.getInstance();
    uniqueId = prefs.getString('onboarding_done') ?? "";

    print("uniqueId = $uniqueId");
    final response = await iaService.overview(uniqueId);
    print("Réponse API : $response"); // 👈 log dans la console
    setState(() {
      messages = response.toList();
      isLoading = response.isNotEmpty ? false : true;
    });
    // Scroll vers le bas (si tu as un ScrollController)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _messageController,
      onChanged: (value) => formattedInputText(value, _messageController),
      focusNode: _focusNode, // 👈 FocusNode ici
      onSubmitted: (value) {
        sendMessage(); // Appelle ta fonction d’envoi
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
        filled: true, // Active le fond
        fillColor: Colors.white, // Fond blanc
        labelText: "Votre message",
        labelStyle: const TextStyle(color: Colors.pink),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.pink, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.pink, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
