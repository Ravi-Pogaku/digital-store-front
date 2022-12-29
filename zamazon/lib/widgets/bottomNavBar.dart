import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.selectedId,
    required this.onTap,
  });

  final int selectedId;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: FlutterI18n.translate(context, "Bottom_NavBar.home_page"),
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: FlutterI18n.translate(context, "Bottom_NavBar.profile_page"),
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_cart),
          label: FlutterI18n.translate(context, "Bottom_NavBar.shopping_cart"),
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: FlutterI18n.translate(context, "Bottom_NavBar.wish_list"),
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: FlutterI18n.translate(context, "Bottom_NavBar.settings"),
          backgroundColor: Colors.orange,
        ),
      ],
      currentIndex: selectedId,
      onTap: onTap,
      type: BottomNavigationBarType.shifting,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      elevation: 0.0,
    );
  }
}
