import 'package:flutter/material.dart';
import 'dart:math';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/models/settings_BLoC.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/widgets/navigateToProductPage.dart';
import 'package:zamazon/widgets/productImage.dart';
import 'package:zamazon/widgets/ratingWidget.dart';

// helper function, to create a big banner for a randomly featured item.

class FeaturedItemWidget extends StatelessWidget {
  const FeaturedItemWidget({Key? key, required this.productList})
      : super(key: key);

  final List<Product> productList;

  @override
  Widget build(BuildContext context) {
    final containerTheme = Provider.of<SettingsBLoC>(context).isDarkMode
        ? Colors.white
        : Colors.grey[900];

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Random random = Random();

    // picks one random product to feature
    Product featuredProduct = productList[random.nextInt(productList.length)];

    return NavigateToProductPage(
      product: featuredProduct,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Featured text
          Container(
            padding: const EdgeInsets.only(top: 25),
            child: Text(
              "Limited Time Featured Item!",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: containerTheme,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Product name
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              "${featuredProduct.title}",
              style: TextStyle(
                fontSize: 20,
                color: containerTheme,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Product rating
          RatingWidget(rating: featuredProduct.rating!),

          // Product price
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              "\$${featuredProduct.price!.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 30,
                color: containerTheme,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          ProductImage(
            backgroundHeight: height * 0.4,
            backgroundWidth: width,
            imageHeight: height * 0.3,
            imageUrl: featuredProduct.imageUrl!,
          ),
        ],
      ),
    );
  }
}
