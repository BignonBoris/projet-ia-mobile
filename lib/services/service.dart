import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static Future<dynamic> post(String url, dynamic data) async {
    return await http
        .post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: data,
          // body: jsonEncode(data.toJson()), // Map<String, dynamic> ici
        )
        .timeout(const Duration(seconds: 20));
  }

  static Future<dynamic> put(String url, dynamic data) async {
    return await http
        .put(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data.toJson()), // Map<String, dynamic> ici
        )
        .timeout(const Duration(seconds: 20));
  }

  static Future<dynamic> get(String url) async {
    return await http
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
        .timeout(const Duration(seconds: 20));
  }
}
