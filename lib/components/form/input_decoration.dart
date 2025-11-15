import 'package:flutter/material.dart';

/// Fonction utilitaire pour générer une décoration de champ uniforme
InputDecoration MyInputDecoration(
  String? label, {
  // IconData icon,
  Color borderColor = Colors.blueAccent,
  Color fillColor = Colors.white,
}) {
  return InputDecoration(
    labelText: label,
    // prefixIcon: Icon(icon, color: borderColor),
    filled: true,
    fillColor: fillColor,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor.withOpacity(0.4), width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
    ),
  );
}
