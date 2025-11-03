import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:projet_ia/services/connexion.dart";
import "package:projet_ia/classes/connexion.dart";
import 'package:shared_preferences/shared_preferences.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  bool _scanned = false;
  ConnexionService connexionService = ConnexionService();

  String? userId = "";

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('onboarding_done');
    });
  }

  void initState() {
    super.initState();
    init();
  }

  Future<void> _sendDataToApi(String scannedData) async {
    String response = await connexionService.createConnexion(
      ConnexionInputModel(guest_id: scannedData, user_id: userId),
    );
    print(response);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("✅ Scan réussi")));
    if (response.length > 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ connexion créer avec succès")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ Echec de création")));
    }
    // const apiUrl = "https://ton-api.com/qr/scan"; // 👉 à remplacer
    // try {
    //   final response = await http.post(
    //     Uri.parse(apiUrl),
    //     headers: {"Content-Type": "application/json"},
    //     body: jsonEncode({"data": scannedData}),
    //   );

    //   if (response.statusCode == 200) {
    //     final json = jsonDecode(response.body);
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text("✅ Scan réussi : ${json['message']}")),
    //     );
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text("⚠️ Erreur API : ${response.statusCode}")),
    //     );
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(SnackBar(content: Text("Erreur de connexion : $e")));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (barcodeCapture) {
        if (_scanned) return; // Empêche les doublons
        final String? code = barcodeCapture.barcodes.first.rawValue;
        if (code != null) {
          setState(() => _scanned = true);
          _sendDataToApi(code);
        }
      },
    );
  }
}
