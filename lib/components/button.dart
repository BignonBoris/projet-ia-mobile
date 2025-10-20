import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  dynamic callAction;
  String? label;
  Color? backgroundColor;
  Color? textColor;

  @override
  Button({
    super.key,
    required this.callAction,
    this.label = "",
    this.backgroundColor = Colors.pinkAccent,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.callAction(), // callback fourni par le parent
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        backgroundColor: this.backgroundColor,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        this.label ?? "",
        style: TextStyle(fontSize: 18, color: this.textColor),
      ),
    );
  }
}
