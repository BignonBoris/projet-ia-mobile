import 'package:flutter/material.dart';

class SimpleBadge extends StatelessWidget {
  final int count;
  final Color bgColor;
  final Color textColor;

  const SimpleBadge({
    super.key,
    required this.count,
    this.bgColor = Colors.redAccent,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox(); // Rien si aucun message

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Text(
        count.toString(),
        style: TextStyle(
          // color: Colors.white,
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
