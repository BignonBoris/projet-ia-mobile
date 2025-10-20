import 'package:flutter/material.dart';

class MenuBottom extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const MenuBottom({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  State<MenuBottom> createState() => _MenuBottomState();
}

class _MenuBottomState extends State<MenuBottom> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type:
          BottomNavigationBarType
              .fixed, // 👈 pour garder tous les items visibles
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
      onTap: widget.onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Rencontre"),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_stories),
          label: "Sagesse",
        ),
        // BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Mots doux"),
        // BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "Quiz"),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "Discussion",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: "Profil",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Paramètres",
        ),
      ],
    );
  }
}
