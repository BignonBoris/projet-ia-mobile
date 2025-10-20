import 'package:flutter/material.dart';

class Button {
  final dynamic callAction;
  final String? label;
  final Color? backgroundColor;
  final Color? textColor;

  // Constructeur pour initialiser les propriétés.
  Button({
    this.callAction,
    this.label = "",
    this.backgroundColor = Colors.pinkAccent,
    this.textColor = Colors.white,
  });
}
