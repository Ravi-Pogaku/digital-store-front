import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/widgets/proceedToCheckOut.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
import 'package:zamazon/widgets/shoppingCartItem.dart';

//IN PROGRESS, users should be able to add/remove items to their shopping carts
// and they will be displayed in this page. IN PROGRESS, checking out items.

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  final SCWLModel _scwlModel = SCWLModel();
  List<Product> products = [];
  var shoppingCartStream =
      SCWLModel().getUserShoppingCartWishList("shoppingCart");

  @override
  Widget build(BuildContext context) {
    products = Provider.of<List<Product>>(context);

    return StreamBuilder(
        stream: shoppingCartStream,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // if data still loading, then show loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          // on error still show a loading indicator but also print the error.
          if (snapshot.hasError) {
            print('SHOPPING-CART-PAGE ERROR: ${snapshot.error.toString()}');
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return Scaffold(
            extendBody: true,
            body: (snapshot.data.isNotEmpty)
                // data has successfully loaded and the user has items in their
                // shopping cart.
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.separated(
                        padding: const EdgeInsets.only(top: 0),
                        itemCount: snapshot.data.length + 1,
                        separatorBuilder: (context, index) {
                          return const Divider(thickness: 2);
                        },
                        itemBuilder: (context, index) {
                          // add whitespace at the bottom of listview
                          if (index == snapshot.data.length) {
                            return const SizedBox(
                              height: kBottomNavigationBarHeight * 2,
                            );
                          }

                          // required for ShoppingCartItem for navigator.push
                          // to ProductPage  when user taps on a WishListItem
                          Product currentProduct = products.firstWhere(
                            (product) =>
                                product.id == snapshot.data[index].productId,
                          );

                          return ShoppingCartItem(
                            product: currentProduct,
                            scwlModel: _scwlModel,
                            scwlItem: snapshot.data[index],
                          );
                        }),
                  )
                // data has successfully loaded but the user has no items in their
                // shopping cart.
                : Center(
                    child: Text(
                      FlutterI18n.translate(context, "ShoppingCartPage.empty"),
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
            bottomNavigationBar: (snapshot.data.isNotEmpty)
                // data has successfully loaded and the user has items in their
                // shopping cart.
                ? ProceedToCheckOutWidget(
                    checkOutItems: snapshot.data,
                  )
                // no items in shopping cart, don't allow them to go to
                // checkout page.
                : null,
          );
        });
  }
}
