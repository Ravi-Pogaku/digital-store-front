import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/bottomNavBarBLoC.dart';
import 'package:zamazon/views/deleteItemsButton.dart';
import 'package:zamazon/widgets/searchButton.dart';
import 'package:zamazon/globals.dart';

// sliver app bar for nestedScrollView in homepage.dart.
// required for cool hiding and reappearing appbar

class MySliverAppBar extends StatelessWidget {
  const MySliverAppBar({super.key, required this.pageTitles});

  final List<Widget> pageTitles;

  static const foregroundColors = {
    0: Colors.black,
  };

  @override
  Widget build(BuildContext context) {
    final currentPageNum =
        Provider.of<BottomNavBarBLoC>(context).currentPageNum;

    return SliverAppBar(
      centerTitle: true,
      backgroundColor: pageBGColors[currentPageNum],
      foregroundColor: (currentPageNum == 0) ? Colors.black : Colors.white,
      elevation: 0.0,
      title: pageTitles.elementAt(currentPageNum),

      // search button on hompage, buttons to empty shoppingcart
      // and wishlist respectively.
      actions: [
        if (currentPageNum == 0)
          const SearchButton()
        else if (currentPageNum == 2)
          const DeleteAllItemsButton(collName: 'shoppingCart')
        else if (currentPageNum == 3)
          const DeleteAllItemsButton(collName: 'wishList')
      ],
    );
  }
}
