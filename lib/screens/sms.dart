import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_id_provider.dart';
import '../services/ia_service.dart';

class SmsScreen extends StatefulWidget {
  const SmsScreen({super.key});

  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  final IAService iaService = IAService();
  Map<String, dynamic> message = {};
  bool isLoading = false;

  Future<void> fetchMessage() async {
    setState(() {
      isLoading = true;
    });

    final uniqueId = context.read<UserIdProvider>().userId;
    final Map<String, dynamic> response = await iaService.getSms(uniqueId);

    // Accéder à "message"
    final String messaged = response['message'];

    print("Message : $messaged");
    // Accéder aussi aux moments et réactions
    final List moments = response['moment'];
    final List reactions = response['reaction'];

    print("Moments : $moments");
    print("Réactions : $reactions");

    print("✅ Données reçues rawData : $response");

    setState(() {
      // message = response["message"] ?? "Pas de message reçu.";
      message = response ?? {"message": "", "moment": [], "reaction": []};
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mots doux… et plus"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // l'icône reload
            onPressed: fetchMessage, // recharge les données
            tooltip: 'Recharger',
          ),
        ],
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child:
            isLoading
                ? const CircularProgressIndicator()
                : ListView(
                  children: [
                    // Message principal
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          message["message"] ?? "",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Moments idéaux
                    const Text(
                      "📅 Moments idéaux :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      (message["moment"] as List).length,
                      (index) => Text(message["moment"][index]),
                    ),
                    const SizedBox(height: 20),

                    // Réactions attendues
                    const Text(
                      "💖 Réactions attendues :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      (message["reaction"] as List).length,
                      (index) => Text(message["reaction"][index]),
                    ),
                  ],
                ),
      ),
    );
  }
}
