import 'package:flutter/material.dart';
import 'dart:math';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/models/settings_BLoC.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/widgets/productImage.dart';

// helper function, to create a big banner for a randomly featured item.

class FeaturedItemWidget extends StatelessWidget {
  const FeaturedItemWidget({Key? key, required this.productList})
      : super(key: key);

  final List<Product> productList;

  @override
  Widget build(BuildContext context) {
    final containerTheme =
        Provider.of<SettingsBLoC>(context).themeMode != ThemeMode.dark
            ? Colors.grey[900]
            : Colors.white;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Random random = Random();
    if (productList.isNotEmpty) {
      Product product = productList[random.nextInt(productList.length)];
      // Product product = productList[0];

      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/ProductPage",
            arguments: {
              'title': 'Product',
              'product': product,
            },
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
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
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                "${product.title}",
                style: TextStyle(
                  fontSize: 20,
                  color: containerTheme,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                "\$${product.price}",
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
              imageUrl: product.imageUrl!,
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
