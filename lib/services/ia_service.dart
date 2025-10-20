import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projet_ia/data/error.dart';

class IAService {
  final String baseUrl = "https://fastapi-ia-74eo.onrender.com/groq";
  // final String baseUrl = "http://127.0.0.1:8000/groq";

  Future<List<Map<String, String>>> getUserMessages(String uniqueId) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/messages/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Map<String, String>.from(item)).toList();
        // return data;
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
      // return [
      //   {"Erreur": e.toString()},
      // ];
    }
  }

  Future<List<Map<String, String>>> initUserMessages(String uniqueId) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/messages/init/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Map<String, String>.from(item)).toList();
        // return data;
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
      // return [
      //   {"Erreur": e.toString()},
      // ];
    }
  }

  Future<List<Map<String, String>>> overview(String uniqueId) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/overview/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Map<String, String>.from(item)).toList();
        // return data;
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
      // return [
      //   {"Erreur": e.toString()},
      // ];
    }
  }

  Future<Map<String, dynamic>> initSagesse(String uniqueId) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/sagesses/init/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Debug pour voir la structure exacte
        print("Réponse API : $data");

        return data;
      } else {
        throw Exception("Erreur API IA: ${response.body}");
      }
    } on TimeoutException catch (_) {
      print("⏱️ La requête a expiré");
      return {"error": Error500};
      // throw Exception("La connexion à l'API a expiré.");
    } on SocketException {
      print(
        "Impossible de se connecter à l'API. Vérifie ta connexion Internet.",
      );
      return {"error": Error500};
    } catch (e) {
      return {"error - ": "$e"};
    }
  }

  Future<Map<dynamic, dynamic>> getSagesse(String uniqueId) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/sagesses/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = response.body == null ? jsonDecode(response.body) : {};

        // Debug pour voir la structure exacte
        print("Réponse API : $data");

        return data;
      } else {
        throw Exception("Erreur API IA: ${response.body}");
      }
    } on TimeoutException catch (_) {
      print("⏱️ La requête a expiré");
      return {"error": Error500};
      // throw Exception("La connexion à l'API a expiré.");
    } on SocketException {
      print(
        "Impossible de se connecter à l'API. Vérifie ta connexion Internet.",
      );
      return {"error": Error500};
    } catch (e) {
      return {"error - ": "$e"};
    }
  }

  Future<Map<String, dynamic>> getNextSagesse(String uniqueId) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/sagesses/new/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Debug pour voir la structure exacte
        print("Réponse API : $data");

        return data;
      } else {
        throw Exception("Erreur API IA: ${response.body}");
      }
    } on TimeoutException catch (_) {
      print("⏱️ La requête a expiré");
      return {"error": Error500};
      // throw Exception("La connexion à l'API a expiré.");
    } on SocketException {
      print(
        "Impossible de se connecter à l'API. Vérifie ta connexion Internet.",
      );
      return {"error": Error500};
    } catch (e) {
      return {"error - ": "$e"};
    }
  }

  Future<String> sendMessage(String uniqueId, String message) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/messages/add/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"message": message}), // Map<String, dynamic> ici
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

  Future<Map<String, String>> sagesse(String uniqueId) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/sagesses/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final Map<String, dynamic> rawData = jsonDecode(response.body);
        final Map<String, String> data = rawData.map(
          (key, value) => MapEntry(key, value.toString()),
        );
        // print("✅ Données reçues : $data");
        return data;
      } else {
        print("Erreur API IA: ${response.body}");
        throw Exception("Erreur API IA: ${response.body}");
      }
    } on TimeoutException catch (_) {
      print("⏱️ La requête a expiré");
      return {"": Error500};
      // throw Exception("La connexion à l'API a expiré.");
    } on SocketException {
      print(
        "Impossible de se connecter à l'API. Vérifie ta connexion Internet.",
      );
      return {"": Error500};
    } catch (e) {
      print(e.toString());
      return {"Erreur": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getSms(String uniqueId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/sms/$uniqueId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final Map<String, dynamic> rawData = jsonDecode(response.body);
        // final Map<String, String> data = rawData.map(
        //   (key, value) => MapEntry(key, value.toString()),
        // );

        return rawData;
      } else {
        throw Exception("Erreur API : ${response.statusCode}");
      }
    } on TimeoutException catch (_) {
      print("⏱️ La requête a expiré");
      return {"": Error500};
      // throw Exception("La connexion à l'API a expiré.");
    } on SocketException {
      print(
        "Impossible de se connecter à l'API. Vérifie ta connexion Internet.",
      );
      return {"": Error500};
    } catch (e) {
      print(e.toString());
      return {"Erreur": e.toString()};
    }
  }

  Future<String> reload(String uniqueId) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/test/reload/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final String data = jsonDecode(response.body);
        // print("✅ Données reçues : $data");
        return data;
      } else {
        print("Erreur API IA: ${response.body}");
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
      print(e.toString());
      return e.toString();
    }
  }
}
