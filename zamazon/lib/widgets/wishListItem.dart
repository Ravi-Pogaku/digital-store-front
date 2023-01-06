import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
import 'package:zamazon/widgets/addToShoppingCartButton.dart';
import 'package:zamazon/widgets/dismissibleBackground.dart';
import 'package:zamazon/widgets/navigateToProductPage.dart';
import 'package:zamazon/widgets/productImage.dart';

// builds an item for the wish list page.
// WishListPage.dart calls this using a listview.builder().

class WishListItem extends StatelessWidget {
  const WishListItem({
    super.key,
    required this.product,
    required this.scwlModel,
    required this.scwlItem,
  });

  // required for pushing to this product's page
  final Product product;

  // interacts with firestore
  final SCWLModel scwlModel;

  // contains relevant info about item in the user's wishlist.
  final ShoppingCartWishListItem scwlItem;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return NavigateToProductPage(
      product: product,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          scwlModel.deleteCartWishListItem(scwlItem);
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
                children: [
                  // PRODUCT NAME
                  Text(
                    scwlItem.title!,
                    style: const TextStyle(fontSize: 17),
                    softWrap: true,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  // PRODUCT PRICE
                  Text(
                    "\$${scwlItem.totalPrice!.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 10),

                  AddToCartButton(product: product, scwlModel: scwlModel),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
