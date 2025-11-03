import 'package:flutter/material.dart';
import "package:projet_ia/screens/profil.dart";
import "package:projet_ia/constants/values.dart";

final GlobalKey<ProfilScreenState> profilKey = GlobalKey<ProfilScreenState>();

class ProfilePopupMenu extends StatelessWidget {
  final void Function(String)? onSelected;

  const ProfilePopupMenu({super.key, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert), // Les 3 petits points
      onSelected: (value) {
        if (onSelected != null) {
          onSelected!(value);
        } else {
          // Comportement par défaut si onSelected n’est pas fourni
          switch (value) {
            case 'create_account':
              // Navigator.pushNamed(context, '/register');
              profilKey.currentState?.changeScreen(screen: profilAccountScreen);
              break;
            case 'login':
              // Navigator.pushNamed(context, '/login');
              profilKey.currentState?.changeScreen(screen: profilLoginScreen);
              break;
            case 'logout':
              // TODO: ajouter ta logique de déconnexion
              break;
            case 'qr_code':
              profilKey.currentState?.changeScreen(screen: profilQRScreen);
              // Navigator.pushNamed(context, '/qr_code');
              break;
            case 'scanner':
              Navigator.pushNamed(context, '/scanner');
              break;
          }
        }
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: profilAccountScreen,
              child: SizedBox(width: 100, child: Text('Mon compte')),
            ),
            const PopupMenuItem(
              value: profilLoginScreen,
              child: Text('Connexion'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(value: profilQRScreen, child: Text('QR Code')),
            const PopupMenuItem(
              value: profilScannerScreen,
              child: Text('Scanner'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Text(
                'Déconnexion',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
    );
  }
}
