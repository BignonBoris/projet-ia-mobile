import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projet_ia/helpers/bottom_sheet_helper.dart';
import 'dart:io';

class ChatMediaAction extends StatefulWidget {
  const ChatMediaAction({super.key});

  @override
  State<ChatMediaAction> createState() => _ChatMediaActionState();
}

class _ChatMediaActionState extends State<ChatMediaAction> {
  File? _mediaFile;
  final ImagePicker _picker = ImagePicker();

  // --- Ouvre la galerie (image ou vidéo)
  Future<void> _pickFromGallery() async {
    final XFile? file = await _picker.pickMedia(); // (image ou vidéo)
    if (file != null) {
      setState(() => _mediaFile = File(file.path));
      showAppBottomSheet(
        context: context,
        child: Column(
          children: [
            // 👉 Affichage de l’image sélectionnée
            if (file.mimeType?.startsWith("image") ?? true)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(file.path),
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            Text("Fichier sélectionné : ${file.name}"),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Annuler")),
                SizedBox(width: 10.0),
                ElevatedButton(onPressed: () {}, child: Text("Envoyer")),
              ],
            ),
          ],
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
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: _pickFromGallery,
            ),
          ),
          const SizedBox(width: 5),
          Padding(
            padding: const EdgeInsets.all(5.0),
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
