import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/widgets/proceedToCheckOut.dart';
import '../models/shoppingCartWishListModel.dart';
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
  // List<Product>? productList;

  final SCWLModel _scwlModel = SCWLModel();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: SCWLModel().getUserShoppingCartWishList("shoppingCart"),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // if data still loading, then show loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // on error still show a loading indicator but also print the error.
          if (snapshot.hasError) {
            print('SHOPPING-CART-PAGE ERROR: ${snapshot.error.toString()}');
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            extendBody: true,
            body: (snapshot.data.isNotEmpty)
                // data has successfully loaded and the user has items in their
                // shopping cart.
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                        padding: const EdgeInsets.only(top: 0),
                        itemCount: snapshot.data.length + 1,
                        itemBuilder: (context, index) {
                          // add whitespace at the bottom of listview
                          if (index == snapshot.data.length) {
                            return const SizedBox(
                              height: 110,
                            );
                          }

                          return ShoppingCartItem(
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
