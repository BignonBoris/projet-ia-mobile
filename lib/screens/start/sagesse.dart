import 'package:flutter/material.dart';

class StartSagesseScreen extends StatefulWidget {
  final VoidCallback onStart;

  const StartSagesseScreen({super.key, required this.onStart});

  @override
  State<StartSagesseScreen> createState() => _StartSagesseScreenState();
}

class _StartSagesseScreenState extends State<StartSagesseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // centré verticalement
            crossAxisAlignment:
                CrossAxisAlignment.center, // centré horizontalement
            children: [
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
              ElevatedButton(
                onPressed: widget.onStart, // callback fourni par le parent
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Commencer",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
