import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projet_ia/classes/maching_guest_input.dart';
import 'package:projet_ia/data/error.dart';
import "package:projet_ia/constants/url.dart";

class IAMatchingService {
  Future<String> initMatching(String uniqueId) async {
    try {
      final response = await http
          .get(
            Uri.parse("$apiMatching/init/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final String data = jsonDecode(response.body);
        return data;
        // return data;
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
      return Error500;
      // return [
      //   {"Erreur": e.toString()},
      // ];
    }
  }

  Future<List<Map<String, dynamic>>> getMatchingMessages(
    String uniqueId,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse("$apiMatching/messages/$uniqueId"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        // final data = jsonDecode(response.body);
        // return data.map((item) {
        //   final map = Map<String, dynamic>.from(item);
        //   return map.map((key, value) => MapEntry(key, value.toString()));
        // }).toList();
      } else {
        print("Erreur API IA: ${response.body}");
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
      print(e.toString());
      return [];
      // return [
      //   {"Erreur": e.toString()},
      // ];
    }
  }

  Future<List<dynamic>> searchMatching(
    String uniqueId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse("$apiMatching/search/$uniqueId/$page/$limit"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        print("response.body");
        print(response.body);
        final List<dynamic> data = jsonDecode(response.body);
        return data.toList();
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
      return [
        {"": Error500},
      ];
      // return [
      //   {"Erreur": e.toString()},
      // ];
    }
  }

  Future<String> sendMessage(String uniqueId, String message) async {
    try {
      final response = await http
          .post(
            Uri.parse("$apiMatching/message/$uniqueId"),
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

  Future<List<Map<String, String>>> opentToMatching(String uniqueId) async {
    try {
      final response = await http
          .get(
            Uri.parse("$apiMatching/open-matching/$uniqueId"),
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

  Future<String> sendMessage_old(String uniqueId, String message) async {
    try {
      final response = await http
          .post(
            Uri.parse("$apiMatching/answer/$uniqueId"),
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
            Uri.parse("$apiMatching/sagesse/$uniqueId"),
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
            Uri.parse('$apiMatching/sms/$uniqueId'),
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
            Uri.parse("$apiMatching/test/reload/$uniqueId"),
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
