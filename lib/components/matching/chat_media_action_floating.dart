import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatMediaFloatingAction extends StatefulWidget {
  const ChatMediaFloatingAction({super.key});

  @override
  State<ChatMediaFloatingAction> createState() =>
      _ChatMediaActionFloatingState();
}

class _ChatMediaActionFloatingState extends State<ChatMediaFloatingAction> {
  File? _mediaFile;
  final ImagePicker _picker = ImagePicker();

  // --- Ouvre la galerie (image ou vidéo)
  Future<void> _pickFromGallery() async {
    final XFile? file = await _picker.pickMedia(); // (image ou vidéo)
    if (file != null) {
      setState(() => _mediaFile = File(file.path));
      _showSnackBar("Fichier sélectionné : ${file.name}");
    }
  }

  // --- Ouvre la caméra (photo ou vidéo)
  Future<void> _captureFromCamera() async {
    // Choix : image ou vidéo (ici on propose une alerte)
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Prendre une photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? file = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (file != null) {
                    setState(() => _mediaFile = File(file.path));
                    _showSnackBar("Photo capturée : ${file.name}");
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Enregistrer une vidéo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? file = await _picker.pickVideo(
                    source: ImageSource.camera,
                  );
                  if (file != null) {
                    setState(() => _mediaFile = File(file.path));
                    _showSnackBar("Vidéo enregistrée : ${file.name}");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 50.0,
        right: 5.0,
      ), // 🔹 marge en bas/droite
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "gallery",
            onPressed: _pickFromGallery,
            backgroundColor: Colors.white,
            child: const Icon(Icons.photo_library),
            tooltip: "Choisir depuis la galerie",
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "camera",
            onPressed: _captureFromCamera,
            backgroundColor: Colors.white,
            child: const Icon(Icons.camera_alt),
            tooltip: "Prendre une photo ou vidéo",
          ),
        ],
      ),
    );
  }
}
