import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget imagePreview(XFile file) {
  const double previewHeight = 220;

  if (kIsWeb) {
    return FutureBuilder<Uint8List>(
      future: file.readAsBytes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: previewHeight,
            color: Colors.black12, // fond pour bien visualiser
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.contain, // 👈 L’IMAGE ENTIÈRE
            ),
          ),
        );
      },
    );
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Container(
      width: double.infinity,
      height: previewHeight,
      color: Colors.black12, // fond optionnel
      child: Image.file(
        File(file.path),
        fit: BoxFit.contain, // 👈 L’IMAGE ENTIÈRE
      ),
    ),
  );
}
