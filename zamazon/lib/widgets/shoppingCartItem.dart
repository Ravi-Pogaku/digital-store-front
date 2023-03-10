import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
import 'package:zamazon/widgets/navigateToProductPage.dart';
import 'package:zamazon/widgets/quantityWidget.dart';
import 'package:zamazon/widgets/dismissibleBackground.dart';
import 'package:zamazon/widgets/productImage.dart';

class ShoppingCartItem extends StatelessWidget {
  const ShoppingCartItem({
    super.key,
    required this.product,
    required this.scwlModel,
    required this.scwlItem,
  });

  final Product product;
  final SCWLModel scwlModel;
  final ShoppingCartWishListItem scwlItem;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return NavigateToProductPage(
      product: product,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            scwlModel.deleteCartWishListItem(scwlItem);
          },
          background: const DismissibleBackground(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ProductImage(
                    imageHeight: height * 0.2,
                    imageWidth: width * 0.4,
                    backgroundHeight: height * 0.21,
                    backgroundWidth: width * 0.41,
                    border: BorderRadius.circular(20),
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    imageFit: BoxFit.contain,
                    imageUrl: scwlItem.imageUrl!,
                  ),

                  // Item quantity buttons (+ and - the quantity of an item)
                  Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 5),
                      child: QuantityWidget(scwlItem: scwlItem))
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),

                    // Product name
                    Text(
                      "${scwlItem.title}",
                      style: const TextStyle(fontSize: 20),
                      softWrap: false,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // Product price
                    Text(
                      "\$${scwlItem.totalPrice!.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // Product size
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: FlutterI18n.translate(
                              context, "BuildItem.size"),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: "${scwlItem.size}",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ]))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
