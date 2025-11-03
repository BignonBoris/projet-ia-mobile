import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRScreen extends StatefulWidget {
  const GenerateQRScreen({super.key});

  @override
  State<GenerateQRScreen> createState() => _GenerateQRScreenState();
}

class _GenerateQRScreenState extends State<GenerateQRScreen> {
  // final String userId;
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImageView(data: userId!, version: QrVersions.auto, size: 250.0),
    );
  }
}
