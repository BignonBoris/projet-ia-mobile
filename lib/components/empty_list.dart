import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String message;

  const EmptyList({super.key, this.message = "Aucun élément trouver"});

  Widget build(BuildContext context) {
    return Text(message);
  }
}
