import 'package:flutter/material.dart';

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool enableDrag = true,
  double height = 400,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true, // permet de prendre toute la hauteur si besoin
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.white, // pour design personnalisé
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return Container(
            height: height,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: child,
            ),
          );
        },
      );
    },
  );
}
