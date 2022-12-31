import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
import 'package:zamazon/widgets/genericSnackBar.dart';
import 'package:zamazon/widgets/sizePickerDialog.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.product,
    required this.scwlModel,
  });

  final Product product;
  final SCWLModel scwlModel;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int? selectedSize = 1;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          fixedSize: Size(width - 80, 40),
        ),
        onPressed: () async {
          if (product.sizeSelection!.length > 1) {
            selectedSize =
                await showSizePickerDialog(context, product.sizeSelection!);
          }

          if (selectedSize != null) {
            await scwlModel
                .addToCartWishList(product, "shoppingCart", size: selectedSize!)
                .then((value) => showSnackBar(
                    context,
                    FlutterI18n.translate(
                        context, "ProductPage.added_to_cart")));
          }
        },
        child: Text(
          FlutterI18n.translate(context, "ProductPage.add_to_cart"),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ));
  }
}
