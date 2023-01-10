import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
import 'package:zamazon/widgets/genericSnackBar.dart';

class AddToWishListButton extends StatelessWidget {
  const AddToWishListButton({
    super.key,
    required this.scwlModel,
    required this.product,
  });

  final Product product;
  final SCWLModel scwlModel;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(shape: const CircleBorder()),
        onPressed: () async {
          await scwlModel.addToCartWishList(product, "wishList").then(
                (value) => showSnackBar(
                  context,
                  FlutterI18n.translate(
                      context, "ProductPage.added_to_wishlist"),
                ),
              );
        },
        child: const Icon(
          Icons.favorite,
          color: Colors.red,
        ));
  }
}
