import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/globals.dart';
import 'package:zamazon/views/SettingsPage.dart';
import 'package:zamazon/widgets/bottomNavBar.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/widgets/customSearchDelegate.dart';
import 'package:zamazon/widgets/featuredItemWidget.dart';
import 'package:zamazon/widgets/productViewWidget.dart';
import 'package:zamazon/controllers/userProfilePage.dart';
import 'package:zamazon/views/ShoppingCartPage.dart';
import 'package:zamazon/views/WishListPage.dart';
import 'dart:math';
import 'package:zamazon/widgets/sliverAppBar.dart';

// Homepage of our digital store front. Presented after successful sign in/ sign up
//TODO make it so once the end of the list is hit, more products will be loaded.

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final categories = [
    'electronics',
    'computer',
    'kitchen',
    'video games',
    'clothes',
    'cosmetics',
    'game console',
    'shoes',
  ];

  // used for the 3 carousel sliders on the home page. below featured item
  int randomCategory = Random().nextInt(8);

  // loaded in build
  List<Product> productList = [];
  List<Widget> navBarPages = [];
  List<Widget> navPageTitles = [];

  int navBarSelectedPage = 0;

  // callback used from the bottom nav bar to change the page
  void navBarOnClicked(int index) {
    setState(() {
      navBarSelectedPage = index;
    });

    // jump to top of page when page changes
    if (_controller.hasClients) {
      _controller.jumpTo(0.0);
    }
  }

  // for jumping back to the top of the page on page changes
  final ScrollController _controller = ScrollController(
    keepScrollOffset: false,
  );

  // default body for the homepage
  Widget homePageBody(List<Product> products) {
    return ListView(
      // removes listview's default top padding
      padding: const EdgeInsets.only(top: 0),
      children: [
        //random featured item
        FeaturedItemWidget(
          productList: productList,
        ),

        //horizontal listview of products of different categories
        ProductViewWidget(
          productList: productList,
          category: categories[randomCategory],
        ),
        ProductViewWidget(
          productList: productList,
          category: categories[randomCategory + 1],
        ),
        ProductViewWidget(
          productList: productList,
          category: categories[randomCategory + 2],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    productList = Provider.of<List<Product>>(context);

    // randomly take a slice of 3 categories from the category list.
    while (randomCategory + 2 > 7) {
      randomCategory = Random().nextInt(8);
    }

    navPageTitles = [
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

    navBarPages = [
      homePageBody(productList),
      const UserProfilePage(title: 'Profile'),
      const ShoppingCartPage(title: 'Shopping Cart'),
      const WishListPage(title: 'Wish List'),
      const SettingsPageWidget(title: 'Settings'),
    ];

    // search button shown on homepage
    Widget homepageSearchWidget = IconButton(
      onPressed: () async {
        // when a user taps a result, it will be returned here.
        await showSearch(context: context, delegate: CustomSearchDelegate());
      },
      icon: const Icon(Icons.search),
    );

    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        // fixes image clipping on the wishlist page. false for other pages
        // because true causes an issue in the shopping cart page.
        extendBody: (navBarSelectedPage == 3) ? true : false,

        body: NestedScrollView(
          controller: _controller,
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              MySliverAppBar(
                title: navPageTitles.elementAt(navBarSelectedPage),

                // search button is only shown on home page
                actions:
                    (navBarSelectedPage == 0) ? [homepageSearchWidget] : null,
              )
            ];
          },

          // if the product list is still being retrieved from firestore
          // home page should be a loading circle, (0 is homepage)
          body: (productList.isEmpty && navBarSelectedPage == 0)
              ? const Center(child: CircularProgressIndicator.adaptive())
              : navBarPages.elementAt(navBarSelectedPage),
        ),
        bottomNavigationBar: BottomNavBar(
          selectedId: navBarSelectedPage,
          onTap: navBarOnClicked,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // I've heard undisposed controllers can cause memory leaks
    _controller.dispose();
  }
}
