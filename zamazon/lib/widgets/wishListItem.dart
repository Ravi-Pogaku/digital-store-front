import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/models/settings_BLoC.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
import 'package:zamazon/widgets/addToShoppingCartButton.dart';
import 'package:zamazon/widgets/dismissibleBackground.dart';
import 'package:zamazon/widgets/productImage.dart';

// builds an item for the wish list page.
// WishListPage.dart calls this using a listview.builder().

class WishListItem extends StatelessWidget {
  const WishListItem({
    super.key,
    required this.scwlModel,
    required this.scwlItem,
  });

  final SCWLModel scwlModel; // interacts with firestore
  final ShoppingCartWishListItem scwlItem; // contains relevant info about item

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: scwlModel.getProduct(scwlItem.productId!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

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
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              scwlModel.deleteCartWishList(scwlItem);
            },
            background: const DismissibleBackground(),
            child: Row(
              children: [
                ProductImage(
                  imageHeight: height * 0.2,
                  imageWidth: width * 0.4,
                  backgroundHeight: height * 0.21,
                  backgroundWidth: width * 0.41,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  border: BorderRadius.circular(15),
                  imageFit: BoxFit.contain,
                  imageUrl: scwlItem.imageUrl!,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // PRODUCT NAME
                      Text(
                        scwlItem.title!,
                        style: const TextStyle(fontSize: 17),
                        softWrap: true,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // PRODUCT PRICE
                      Text(
                        "\$${scwlItem.totalPrice!.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      AddToCartButton(
                          product: snapshot.data!, scwlModel: scwlModel),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
