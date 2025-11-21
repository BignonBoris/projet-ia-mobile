import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projet_ia/helpers/bottom_sheet_helper.dart';
import 'package:projet_ia/helpers/show_image.dart';
import "package:projet_ia/services/connexion.dart";
import 'dart:io';

class ChatMediaAction extends StatefulWidget {
  final String connexion_id;
  final String user_id;
  const ChatMediaAction({
    super.key,
    required this.connexion_id,
    required this.user_id,
  });

  @override
  State<ChatMediaAction> createState() => _ChatMediaActionState();
}

class _ChatMediaActionState extends State<ChatMediaAction> {
  File? _mediaFile;
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile; // (image ou vidéo)

  void sendFile() async {
    // final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await ConnexionService().sendFile(
        widget.connexion_id,
        widget.user_id,
        pickedFile!,
      );
    }
  }

  // --- Ouvre la galerie (image ou vidéo)
  Future<void> _pickFromGallery() async {
    final XFile? file = await _picker.pickMedia(); // (image ou vidéo)
    if (file != null) {
      setState(() {
        _mediaFile = File(file.path);
        pickedFile = file;
      });
      showAppBottomSheet(
        context: context,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // ⚡ ne prend que la hauteur nécessaire
              children: [
                if (file.mimeType?.startsWith("image") ?? true)
                  imagePreview(file),

                const SizedBox(height: 20),

                // Text("Fichier sélectionné : ${file.name}"),
                // const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Annuler"),
                    ),
                    const SizedBox(width: 50),
                    ElevatedButton(
                      onPressed: () => sendFile(),
                      child: const Text("Envoyer"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
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
        bottom: 0.0,
        right: 0.0,
      ), // 🔹 marge en bas/droite
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: _pickFromGallery,
            ),
          ),
          const SizedBox(width: 1),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: _pickFromGallery,
            ),
          ),
          // FloatingActionButton(
          //   heroTag: "gallery",
          //   onPressed: _pickFromGallery,
          //   backgroundColor: Colors.white,
          //   child: const Icon(Icons.photo_library),
          //   tooltip: "Choisir depuis la galerie",
          // ),
          // const SizedBox(height: 12),
          // FloatingActionButton(
          //   heroTag: "camera",
          //   onPressed: _captureFromCamera,
          //   backgroundColor: Colors.white,
          //   child: const Icon(Icons.camera_alt),
          //   tooltip: "Prendre une photo ou vidéo",
          // ),
        ],
      ),
    );
  }
}
