import 'package:flutter/material.dart';

// using setstate to update the currentPageIndex for the bottomNavBar
// caused lag from rebuilding the homepage.
// this provider ensures that only the bottomNavBar is rebuilt lessening the lag
// between page changes.

class BottomNavBarBLoC extends ChangeNotifier {
  int currentPageNum = 0;

  void updatePage(int newPageNum) {
    currentPageNum = newPageNum;
    notifyListeners();
  }
}
