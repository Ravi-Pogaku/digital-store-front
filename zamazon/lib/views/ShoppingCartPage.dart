import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/widgets/proceedToCheckOut.dart';
import '../models/shoppingCartWishListModel.dart';
import 'package:zamazon/widgets/buildCartItem.dart';

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
    double height = MediaQuery.of(context).size.height;

    return StreamBuilder(
        stream: SCWLModel().getUserShoppingCartWishList("shoppingCart"),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Scaffold(
            body: (snapshot.data.isEmpty)
                ? Center(
                    child: Text(
                      FlutterI18n.translate(context, "ShoppingCartPage.empty"),
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                        padding: const EdgeInsets.only(top: 0),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return BuildCartItem(
                            scwlItem: snapshot.data[index],
                            width: width,
                          );
                        }),
                  ),
            bottomNavigationBar: snapshot.data.isNotEmpty
                ? ProceedToCheckOutWidget(
                    checkOutItems: snapshot.data,
                  )
                : Container(
                    height: 0,
                  ),
          );
        });
  }
}
