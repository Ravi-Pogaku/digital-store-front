import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
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

class _WishListPageState extends State<WishListPage>
    with AutomaticKeepAliveClientMixin {
  final SCWLModel _scwlModel = SCWLModel();
  List<Product> products = [];
  var wishListStream = SCWLModel().getUserShoppingCartWishList('wishList');

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    products = Provider.of<List<Product>>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return StreamBuilder(
        stream: wishListStream,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // if data still being retrieved, show loading circle.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
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
            child: ListView.separated(
                // removes default listview top padding
                padding: const EdgeInsets.only(top: 0),
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) {
                  return const Divider(thickness: 2);
                },
                itemBuilder: (context, index) {
                  // required for WishListItem for navigator.push to ProductPage
                  // when user taps on a WishListItem
                  Product currentProduct = products.firstWhere(
                    (product) => product.id == snapshot.data[index].productId,
                  );

                  return WishListItem(
                    scwlModel: _scwlModel,
                    scwlItem: snapshot.data[index],
                    product: currentProduct,
                  );
                }),
          );
        });
  }
}
