import 'package:flutter/material.dart';
import 'package:projet_ia/components/button.dart';

class StartChatScreen extends StatefulWidget {
  final VoidCallback onStart;

  const StartChatScreen({super.key, required this.onStart});

  @override
  State<StartChatScreen> createState() => _StartChatScreenState();
}

class _StartChatScreenState extends State<StartChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // centré verticalement
          crossAxisAlignment:
              CrossAxisAlignment.center, // centré horizontalement
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 120,
              color: Colors.pink,
            ),
            const SizedBox(height: 20),
            const Text(
              "Bienvenue Boris !",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Je suis ravi de t'accueillir cette espace intime d'échange ! Je suis avec votre conseillé en relation sentimental.\n"
              "Appuyez sur le bouton ci-dessous pour commencer.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            Button(callAction: () => widget.onStart, label: "Commencer"),
            // ElevatedButton(
            //   onPressed: widget.onStart, // callback fourni par le parent
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 32,
            //       vertical: 16,
            //     ),
            //     backgroundColor: Colors.pinkAccent,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            //   child: const Text(
            //     "Commencer",
            //     style: TextStyle(fontSize: 18, color: Colors.white),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
