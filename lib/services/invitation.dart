import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projet_ia/data/error.dart';
import 'package:projet_ia/classes/maching_guest_input.dart';

class InvitationService {
  final String baseUrl = "https://fastapi-ia-74eo.onrender.com/matching";
  // final String baseUrl = "http://127.0.0.1:8000/matching";

  Future<String> updateInvitation(
    String invitation_id,
    MachingGuestInput data,
  ) async {
    print(data.toJson());
    try {
      final response = await http
          .put(
            Uri.parse("$baseUrl/invitation/$invitation_id"),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data.toJson()), // Map<String, dynamic> ici
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

  Future<String> sendInvitation(String uniqueId, MachingGuestInput data) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/invitation/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "guest_id": data.guest_id,
              "guest_resume": data.guest_resume,
              "compatibility_score": data.compatibility_score,
              "reason": data.reason,
              "advice": data.advice,
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

  Future<List<dynamic>> getAllInvitations(String uniqueId) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/invitations/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data;
      } else {
        throw Exception("Erreur API IA: ${response.body}");
      }
    } on TimeoutException catch (_) {
      print("⏱️ La requête a expiré");
      return [];
      // throw Exception("La connexion à l'API a expiré.");
    } on SocketException {
      print(
        "Impossible de se connecter à l'API. Vérifie ta connexion Internet.",
      );
      return [];
    } catch (e) {
      print("Erreur: $e");
      return [];
    }
  }
}
