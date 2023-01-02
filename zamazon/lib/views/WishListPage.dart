import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/widgets/genericSnackBar.dart';
import 'package:zamazon/widgets/sizePickerDialog.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/settings_BLoC.dart';
import 'package:zamazon/widgets/wishListItem.dart';

// Similar to shopping cart page, except users will only be able to
// add wishlist items to shopping cart, they will not be able to check out items
// from this page.

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  final SCWLModel _scwlModel = SCWLModel();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return StreamBuilder(
        stream: SCWLModel().getUserShoppingCartWishList("wishList"),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // if connectionstate == waiting (data still being retrieved)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // stream has successfully loaded but there are no items are in the
          // user's wishlist.
          if (snapshot.data.isEmpty) {
            return Center(
                child: Text(
              FlutterI18n.translate(context, "WishListPage.empty"),
              softWrap: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25),
            ));
          }

          // stream has successfully loaded and there are items present in
          // the user's wishlist.
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
                // removes default top padding
                padding: const EdgeInsets.only(top: 0),
                itemCount: snapshot.data.length + 1,
                itemBuilder: (context, index) {
                  // add whitespace at the bottom of listview
                  if (index == snapshot.data.length) {
                    return const SizedBox(
                      height: kBottomNavigationBarHeight,
                    );
                  }

                  ShoppingCartWishListItem scwlItem = snapshot.data[index];
                  return WishListItem(
                    scwlModel: _scwlModel,
                    scwlItem: scwlItem,
                  );
                }),
          );
        });
  }
}
