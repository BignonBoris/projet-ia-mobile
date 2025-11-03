import 'package:flutter/material.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({Key? key}) : super(key: key);
  @override
  State<ProfileDrawer> createState() => ProfileDrawerState();
}

class ProfileDrawerState extends State<ProfileDrawer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // const DrawerHeader(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Colors.blue, Colors.indigo],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //   ),
          //   child: Center(
          //     child: Text(
          //       "Mon Menu",
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 22,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          ListTile(
            leading: const Icon(Icons.person_add_alt_1),
            title: const Text("Créer un compte"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/register');
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text("Se connecter"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text("Mon QR Code"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/qrcode');
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: const Text("Scanner un QR Code"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/scanner');
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Se déconnecter",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              // TODO: implémente ta fonction logout()
            },
          ),
        ],
      ),
    );
  }
}
