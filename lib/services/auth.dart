import 'dart:async';
import 'dart:io';
import 'dart:convert';
import "package:projet_ia/classes/auth.dart";
import "package:projet_ia/constants/url.dart";
import "package:projet_ia/services/service.dart";

class AuthService {
  // Future<Map<String, dynamic>?> getUser(String uniqueId) async {
  Future<Map<String, dynamic>?> login(AuthInputModel authInputData) async {
    try {
      final response = await Api.post(
        "$apiAuth/login",
        jsonEncode({
          "email": authInputData.email,
          "password": authInputData.password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print("Erreur API IA: ${response.body}");
        throw Exception("Erreur API IA: ${response.body}");
      }
    } on TimeoutException catch (_) {
      print("⏱️ La requête a expiré");
      return null;
      // throw Exception("La connexion à l'API a expiré.");
    } on SocketException {
      print(
        "Impossible de se connecter à l'API. Vérifie ta connexion Internet.",
      );
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
