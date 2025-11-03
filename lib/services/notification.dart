import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:projet_ia/data/error.dart';
import "package:projet_ia/classes/notification.dart";
import "package:projet_ia/constants/url.dart";
import "package:projet_ia/services/service.dart";

class NotificationService {
  Future<NotificationModel?> sendNotification(
    NotificationModel notifData,
  ) async {
    print({notifData.toJson()});
    try {
      final response = await Api.post(
        "$apiNotification/send",
        jsonEncode(notifData.toJson()),
      );

      if (response.statusCode == 200) {
        print({notifData});
        final data = jsonDecode(response.body);
        print("Réponse API Not: $data");

        return data;
      } else {
        print(response);
        throw Exception("Erreur API IA: ${response.body}");
      }
    } on TimeoutException catch (_) {
      print("⏱️ La requête a expiré");
      return null;
    } on SocketException {
      print(
        "Impossible de se connecter à l'API. Vérifie ta connexion Internet.",
      );
      return null;
    } catch (e) {
      return null;
    }
  }
}
