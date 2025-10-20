import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projet_ia/classes/user.dart';

class UserService {
  final String baseUrl = "https://fastapi-ia-74eo.onrender.com/groq";
  // final String baseUrl = "http://127.0.0.1:8000/groq";
  String Error500 =
      "Connexion Internet absente. Veuillez vérifier votre connexion et réessayer";

  Future<String> createUser(User userData) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/user"),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "name": userData.name,
              "age": userData.age,
              "sexe": userData.sexe,
              // "country": userData.country,
            }), // Map<String, dynamic> ici
          )
          .timeout(const Duration(seconds: 20));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Debug pour voir la structure exacte
        print("Réponse API : $data");

        return data?.toString() ?? "";
      } else {
        throw Exception("Erreur API IA: ${response.body}");
      }
    } on TimeoutException catch (_) {
      print("⏱️ La requête a expiré");
      return Error500;
      // throw Exception("La connexion à l'API a expiré.");
    } on SocketException {
      print(
        "Impossible de se connecter à l'API. Vérifie ta connexion Internet.",
      );
      return Error500;
    } catch (e) {
      return "Erreur: $e";
    }
  }
}
