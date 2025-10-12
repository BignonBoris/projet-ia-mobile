import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:projet_ia/components/message.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void pickColor(Color currentColor, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Choisir une couleur"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
              enableAlpha: false,
              displayThumbColor: true,
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Fermer"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Paramètres du Chat"),
      //   backgroundColor: Colors.pink,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Text("Parametre utilisateur"),
                  const Divider(),
                  ListTile(
                    title: const Text("Couleur des messages Utilisateur"),
                    trailing: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: settingsProvider.userMessageColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: () {
                      pickColor(settingsProvider.userMessageColor, (color) {
                        settingsProvider.setUserMessageColor(color);
                      });
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      "Couleur de fond des messages Utilisateur",
                    ),
                    trailing: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: settingsProvider.userMessageBgColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: () {
                      pickColor(settingsProvider.userMessageBgColor, (color) {
                        settingsProvider.setUserMessageBgColor(color);
                      });
                    },
                  ),
                  const Divider(),
                  Message(message: "Je suis l'utilisateur", role: "user"),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text("Parametre IA"),
                  const Divider(),
                  ListTile(
                    title: const Text("Couleur des messages IA"),
                    trailing: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: settingsProvider.aiMessageColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: () {
                      pickColor(settingsProvider.aiMessageColor, (color) {
                        settingsProvider.setAiMessageColor(color);
                      });
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text("Couleur de fond des messages IA"),
                    trailing: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: settingsProvider.aiMessageBgColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: () {
                      pickColor(settingsProvider.aiMessageBgColor, (color) {
                        settingsProvider.setAiMessageBgColor(color);
                      });
                    },
                  ),
                  const Divider(),
                  Message(message: "Je suis Nathalie", role: "assitant"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
