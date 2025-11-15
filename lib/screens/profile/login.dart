import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/providers/user_provider.dart';
import "package:projet_ia/services/auth.dart";
import "package:projet_ia/classes/auth.dart";
import "package:projet_ia/screens/home.dart";
import "package:projet_ia/components/form/text.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService authService = AuthService();
  Map<String, dynamic>? user;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _login(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    user = await authService.login(
      AuthInputModel(password: password, email: email),
    );

    if (user != null) {
      // Simule une authentification
      context.read<UserProvider>().updateUser({
        "email": user!["email"],
        "pseudo": user!["pseudo"],
        "country": user!["country"],
        "occupation": user!["occupation"],
        "phone": user!["phone"],
        "sexe": user!["sexe"],
        "dateOfBirth": user!["dateOfBirth"],
        // "email": email,
        // "pseudo": email.split("@").first,
      });

      await prefs.setString('onboarding_done', user!["user_id"]);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Echec de connexion.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.favorite, size: 80, color: Colors.pink),
                const SizedBox(height: 30),
                const Text(
                  "Connexion",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                TextInput(controller: emailController, label: "Email"),
                // TextField(
                //   controller: emailController,
                //   decoration: const InputDecoration(
                //     labelText: "Email",
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                const SizedBox(height: 20),
                TextInput(
                  controller: passwordController,
                  label: "Mot de passe",
                  isPassword: true,
                ),
                // TextField(
                //   controller: passwordController,
                //   obscureText: true,
                //   decoration: const InputDecoration(
                //     labelText: "Mot de passe",
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Se connecter",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
