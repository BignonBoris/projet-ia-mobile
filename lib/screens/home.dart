import 'package:flutter/material.dart';
import 'package:projet_ia/data/menu.dart';
import 'package:projet_ia/components/menu_bottom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  List<Map<String, bool>> actions = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('matching_onbording'));
    actions = [
      {"matching_onbording": prefs.getBool('matching_onbording') ?? true},
      {"sagesse_onbording": prefs.getBool('sagesse_onbording') ?? true},
    ];
    setState(() {
      actions = actions;
    });
  }

  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink, // Couleur de fond
        title: Text(
          menus[_selectedIndex]["title"] ?? "Coach",
          style: const TextStyle(
            color: Colors.white, // Texte rose
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: menus[_selectedIndex]["actions"](context),
        centerTitle: false, // Centre le texte
        iconTheme: const IconThemeData(color: Colors.white), // Icônes roses
      ),
      // drawer: const Menu(),
      backgroundColor: Colors.grey[100], // Fond gris clair du body
      body: menus[_selectedIndex]["widget"],
      bottomNavigationBar: MenuBottom(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
