import 'package:flutter/material.dart';

class ButtonModel {
  final dynamic callAction;
  final String? label;
  final Color? backgroundColor;
  final Color? textColor;

  // Ajoutez le mot-clé 'const' au constructeur
  const ButtonModel({
    this.callAction,
    this.label = "",
    this.backgroundColor = Colors.pinkAccent,
    this.textColor = Colors.white,
  });
}
