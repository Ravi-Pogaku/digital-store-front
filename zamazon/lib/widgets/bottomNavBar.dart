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
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: '',
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: '',
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '',
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
