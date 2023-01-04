import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.pageController,
    required this.selectedId,
  });

  final PageController pageController;
  final int selectedId;

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
      onTap: (pageNum) {
        pageController.animateToPage(
          pageNum,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
      type: BottomNavigationBarType.shifting,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      elevation: 0.0,
    );
  }
}
