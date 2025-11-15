import 'package:flutter/material.dart';
import "package:projet_ia/screens/profil.dart";
import "package:projet_ia/constants/values.dart";
import 'package:projet_ia/providers/user_provider.dart';
import "package:projet_ia/providers/menu_provider.dart";
import 'package:provider/provider.dart';
import "package:projet_ia/services/users.dart";
import 'package:projet_ia/classes/user.dart';

final GlobalKey<ProfilScreenState> profilKey = GlobalKey<ProfilScreenState>();

class ProfilePopupMenu extends StatefulWidget {
  final void Function(String)? onSelected;

  @override
  const ProfilePopupMenu({super.key, this.onSelected});
  State<ProfilePopupMenu> createState() => ProfilePopupMenuState();
}

class ProfilePopupMenuState extends State<ProfilePopupMenu> {
  bool menuStatus = false;
  UserProvider userProvider = UserProvider();
  MenuProvider menuProvider = MenuProvider();

  void init() async {
    menuStatus = await getBoolPref("profil_onboarding") ?? false;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void _logout() async {
    await userProvider.clearUser();
    menuProvider.setProfilSelectScreen(screen: profilLoginScreen);
    UserService userService = UserService();
    final response = await userService.createUser(new UserModel.empty());
    if (response.length == 36) {
      userProvider.setUserId(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = context.watch<UserProvider>();

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert), // Les 3 petits points
      onSelected: (value) {
        if (widget.onSelected != null) {
          widget.onSelected!(value);
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
      itemBuilder: (context) {
        final items = <PopupMenuEntry<String>>[
          const PopupMenuItem(
            value: profilAccountScreen,
            child: SizedBox(width: 100, child: Text('Mon compte')),
          ),
        ];
        if (userProvider.pseudo == '') {
          items.add(
            const PopupMenuItem(
              value: profilLoginScreen,
              child: Text('Connexion'),
            ),
          );
        }
        if (userProvider.pseudo != "") {
          items.add(const PopupMenuDivider());
          items.add(
            const PopupMenuItem(value: profilQRScreen, child: Text('QR Code')),
          );
          items.add(
            const PopupMenuItem(
              value: profilScannerScreen,
              child: Text('Scanner'),
            ),
          );

          items.add(const PopupMenuDivider());
          items.add(
            PopupMenuItem(
              value: 'logout',
              child: GestureDetector(
                onTap: () {
                  _logout();
                },
                child: Text(
                  'Déconnexion',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
          );
        }

        return items;
      },
    );
  }
}
