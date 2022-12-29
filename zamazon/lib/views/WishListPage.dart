import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/widgets/genericSnackBar.dart';
import 'package:zamazon/widgets/sizePickerDialog.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/themeBLoC.dart';

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
          return (snapshot.data.isEmpty)
              ? Center(
                  child: Text(
                  FlutterI18n.translate(context, "WishListPage.empty"),
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ))
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 0),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        ShoppingCartWishListItem scwlItem =
                            snapshot.data[index];
                        return buildWishListItem(scwlItem, width);
                      }),
                );
        });
  }

  Widget buildWishListItem(ShoppingCartWishListItem scwlItem, double width) {
    return InkWell(
      onTap: () async {
        Navigator.pushNamed(
          context,
          "/ProductPage",
          arguments: {
            'title': 'Product',
            'product': await SCWLModel().getProduct(scwlItem.productId!)
          },
        );
      },
      // change these if needed
      // splashColor : Colors.blue,
      // highlightColor: Colors.black,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _scwlModel.deleteCartWishList(scwlItem);
            },
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color:
                    Provider.of<ThemeBLoC>(context).themeMode == ThemeMode.dark
                        ? Colors.grey[700]
                        : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  // TODO: add real trashcan icon
                  Icon(
                    Icons.delete,
                  )
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width / 2.5,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.network(
                    scwlItem.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        scwlItem.title!,
                        style: const TextStyle(fontSize: 17),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "\$${scwlItem.totalPrice!}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              fixedSize: Size(width / 2, 20)),
                          onPressed: () async {
                            int? value = await showSizePickerDialog(
                                context, scwlItem.sizeSelection!);
                            if (value != null) {
                              if (!mounted) return;
                              showSnackBar(context, FlutterI18n.translate(context, "WishListPage.added_to_cart"));
                              Product product = await SCWLModel()
                                  .getProduct(scwlItem.productId!);
                              _scwlModel.addToCartWishList(
                                  product, "shoppingCart",
                                  size: value);
                            }
                          },
                          child: Text(
                            FlutterI18n.translate(context, "WishListPage.add_to_cart"),
                            style: TextStyle(color: Colors.black),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
