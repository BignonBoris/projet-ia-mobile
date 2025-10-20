import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ia_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/providers/menu_provider.dart';
import 'package:projet_ia/components/start.dart';
import 'package:projet_ia/constants/texts.dart';

class SagesseScreen extends StatefulWidget {
  const SagesseScreen({super.key}); // 👈 accepte la Ke

  @override
  State<SagesseScreen> createState() => SagesseScreenState();
}

class SagesseScreenState extends State<SagesseScreen> {
  bool isLoading = true;
  final IAService iaService = IAService();
  Map<dynamic, dynamic> sagesse = {};
  String uniqueId = "";
  bool sagesseOnBoardingCompleted = false;
  MenuProvider menuProvider = MenuProvider();

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    sagesseOnBoardingCompleted = prefs.getBool('sagesse_onboarding') ?? false;
    if (sagesseOnBoardingCompleted == false) {
      // SI L'ONBOARDING  N'EST PAS ENCORE FAIT
      setState(() {
        sagesse = {};
        isLoading = false;
        sagesseOnBoardingCompleted = sagesseOnBoardingCompleted;
      });
    } else {
      await menuProvider.loadSagesseOnboardingStatus();
      // SI L'ONBOARDING  EST  FAIT
      uniqueId = prefs.getString('onboarding_done') ?? "";

      print("uniqueId = $uniqueId");
      final response = await iaService.getNextSagesse(uniqueId);

      setState(() {
        sagesse = response;
        isLoading = false;
        sagesseOnBoardingCompleted = sagesseOnBoardingCompleted;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => init());
  }

  void startSagesse(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    uniqueId = prefs.getString('onboarding_done') ?? "";

    menuProvider = context.read<MenuProvider>();
    menuProvider.completeSagesseOnboarding();
    final response = await iaService.initSagesse(uniqueId);
    print("Réponse API : $response"); // 👈 log dans la console
    setState(() {
      sagesse = response;
      isLoading = false;
      sagesseOnBoardingCompleted = true;
    });
  }

  void nextSagesse() async {
    final prefs = await SharedPreferences.getInstance();
    uniqueId = prefs.getString('onboarding_done') ?? "";

    print("uniqueId = $uniqueId");
    final response = await iaService.getNextSagesse(uniqueId);
    print("Réponse API : $response"); // 👈 log dans la console
    setState(() {
      sagesse = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final citation = sagesse['sagesse'].toString();
    final explication = sagesse["explanation"].toString();
    final lecon = sagesse["lesson"].toString();
    final data = introTexts["sagesse"]!;

    return Center(
      child:
          isLoading
              ? const CircularProgressIndicator()
              : !sagesseOnBoardingCompleted
              ? StartScreen(
                startAction: () => startSagesse(context),
                title: data["title"]!,
                description: data["description"]!,
                icon: Icons.auto_stories,
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      size: 40,
                      color: Colors.pink,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      citation,
                      style: const TextStyle(
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "🧠 Explication :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      explication,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "📌 Leçon à retenir :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lecon,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
