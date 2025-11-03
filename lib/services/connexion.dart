import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projet_ia/data/error.dart';
import "package:projet_ia/constants/url.dart";
import "package:projet_ia/classes/connexion.dart";
import "package:projet_ia/services/service.dart";

class ConnexionService {
  Future<List<Map<String, dynamic>>> getAllUserConnexions(
    String uniqueId,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse("$apiMatching/connexions/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        print("Erreur API IA: ${response.body}");
        throw Exception("Erreur API IA: ${response.body}");
      }
    } on TimeoutException catch (_) {
      print("⏱️ La requête a expiré");
      return [
        {"": Error500},
      ];
      // throw Exception("La connexion à l'API a expiré.");
    } on SocketException {
      print(
        "Impossible de se connecter à l'API. Vérifie ta connexion Internet.",
      );
      return [
        {"": Error500},
      ];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<String> sendMessage(
    String connexion_id,
    String uniqueId,
    String message,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse("$apiMatching/connexion/message/$connexion_id"),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "user_id": uniqueId,
              "message": message,
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

  Future<String> createConnexion(ConnexionInputModel connexionInputData) async {
    try {
      final response = await Api.post(
        "$apiConnexion",
        jsonEncode({
          "user_id": connexionInputData.user_id,
          "guest_id": connexionInputData.guest_id,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

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
