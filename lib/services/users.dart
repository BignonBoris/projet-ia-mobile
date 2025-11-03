import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:projet_ia/data/error.dart';
import "package:projet_ia/classes/user.dart";
import "package:projet_ia/constants/url.dart";
import "package:projet_ia/services/service.dart";

class UserService {
  Future<String> createUser(UserModel userData) async {
    try {
      final response = await Api.post(
        "$apiUser",
        jsonEncode({
          "name": userData.name,
          "age": userData.age,
          "sexe": userData.sexe,
          // "dateOfBirth": userData.dateOfBirth!.toIso8601String(),
          // "country": userData.country,
        }),
      );
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

  Future<String> updateUser(String user_id, UserModel data) async {
    print("$apiUser/$user_id");
    try {
      final response = await Api.put("$apiUser/$user_id", data);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Debug pour voir la structure exacte
        print("Réponse API : $data");

        return data?.toString() ?? "";
      } else {
        print(response);
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
      print("Erreur: $e");
      return "Erreur: $e";
    }
  }

  // Future<Map<String, dynamic>?> getUser(String uniqueId) async {
  Future<UserModel?> getUser(String uniqueId) async {
    try {
      final response = await Api.get("$apiUser/$uniqueId");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
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

  Future<void> uploadProfileImage(String userId, XFile image) async {
    final uri = Uri.parse("$apiUser/upload-profile-image/$userId");

    var request = http.MultipartRequest("POST", uri);
    request.fields['user_id'] = userId;
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print("✅ Image envoyée avec succès !");
      final respStr = await response.stream.bytesToString();
      print(respStr);
    } else {
      print("❌ Erreur: ${response.statusCode}");
    }
  }
}
