import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './form.dart';

//
// 1️⃣ INTRO SCREEN
//
class MatchingIntroScreen extends StatelessWidget {
  const MatchingIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, size: 120, color: Colors.pink),
              const SizedBox(height: 20),
              const Text(
                "Découvrez des personnes qui partagent vos besoins et envies 💕",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('matching_onbording', false);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchingFormScreen(),
                    ),
                  );
                },
                child: const Text("Commencer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
