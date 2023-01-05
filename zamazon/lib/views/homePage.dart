import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/globals.dart';
import 'package:zamazon/models/bottomNavBarBLoC.dart';
import 'package:zamazon/views/SettingsPage.dart';
import 'package:zamazon/widgets/bottomNavBar.dart';
import 'package:zamazon/widgets/homePageBody.dart';
import 'package:zamazon/controllers/userProfilePage.dart';
import 'package:zamazon/views/ShoppingCartPage.dart';
import 'package:zamazon/views/WishListPage.dart';
import 'package:zamazon/widgets/sliverAppBar.dart';

// Homepage of our digital store front. Presented after successful sign in/ sign up
//TODO make it so once the end of the list is hit, more products will be loaded.

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // loaded in build
  List<Widget> pages = [];
  List<Widget> pageTitles = [];

  int currentPageNum = 0;

  final int randomCategory = Random().nextInt(6);

  // for jumping back to the top of the page on page changes
  final ScrollController scrollController = ScrollController(
    keepScrollOffset: false,
  );

  final PageController pageController = PageController();

  void changePageAnimation() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    // slide to top of page
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    pageTitles = [
      // app logo for homepage
      Image.network(
        zamazonLogo,
        width: 125,
      ),
      Text(FlutterI18n.translate(context, "Appbar.profile")),
      Text(FlutterI18n.translate(context, "Appbar.shopping_cart")),
      Text(FlutterI18n.translate(context, "Appbar.wish_list")),
      Text(FlutterI18n.translate(context, "Appbar.settings")),
    ];

    return Scaffold(
      // fixes image clipping on the wishlist page. false for other pages
      // because true causes an issue in the shopping cart page.
      body: NestedScrollView(
        controller: scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            MySliverAppBar(
              pageTitles: pageTitles,
            )
          ];
        },
        body: PageView(
          controller: pageController,
          physics: const AlwaysScrollableScrollPhysics(),
          onPageChanged: (pageNum) {
            Provider.of<BottomNavBarBLoC>(
              context,
              listen: false,
            ).updatePage(pageNum);

            changePageAnimation();
          },
          children: const [
            HomePageBody(),
            UserProfilePage(title: 'Profile'),
            ShoppingCartPage(title: 'Shopping Cart'),
            WishListPage(title: 'Wish List'),
            SettingsPageWidget(title: 'Settings'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        pageController: pageController,
      ),
    );
  }

  @override
  void dispose() {
    // I've heard undisposed controllers can cause memory leaks
    scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }
}
