import 'package:flutter/material.dart';
import 'package:projet_ia/components/button.dart';

class StartScreen extends StatelessWidget {
  final VoidCallback startAction;
  final IconData? icon;
  final String? title;
  final String? description;
  final String? btnText;
  final String? btnText2;

  @override
  StartScreen({
    super.key,
    required this.startAction,
    this.icon = Icons.face,
    this.title = "",
    this.description = "",
    this.btnText = "Commencer",
    this.btnText2 = "",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // centré verticalement
          crossAxisAlignment:
              CrossAxisAlignment.center, // centré horizontalement
          children: [
            Icon(this.icon, size: 120, color: Colors.pink),
            const SizedBox(height: 20),
            Text(
              this.title ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              this.description ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            Button(callAction: () => this.startAction, label: this.btnText),
            if (this.btnText2!.isNotEmpty)
              {
                const SizedBox(height: 20),
                Button(
                  callAction: () => this.startAction,
                  label: this.btnText,
                  backgroundColor: Colors.white,
                  textColor: Colors.pinkAccent,
                ),
              },
          ],
        ),
      ),
    );
  }
}
