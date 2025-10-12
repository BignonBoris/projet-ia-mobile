import 'package:flutter/material.dart';
import 'package:projet_ia/data/menu.dart';
import 'package:projet_ia/components/menu_bottom.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink, // Couleur de fond
        title: Text(
          menus[_selectedIndex]["title"] ?? "Nathalie",
          style: const TextStyle(
            color: Colors.white, // Texte rose
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: menus[_selectedIndex]["actions"](context),
        // [
        //   IconButton(
        //     icon: const Icon(Icons.refresh), // l'icône reload
        //     onPressed: () {
        //       print("refresh");
        //     }, // recharge les données
        //     tooltip: 'Recharger',
        //   ),
        // ],
        centerTitle: false, // Centre le texte
        iconTheme: const IconThemeData(color: Colors.white), // Icônes roses
      ),
      // drawer: const Menu(),
      backgroundColor: Colors.grey[200], // Fond gris clair du body
      body: menus[_selectedIndex]["widget"],
      bottomNavigationBar: MenuBottom(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
