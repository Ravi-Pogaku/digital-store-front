import 'package:flutter/material.dart';
import 'package:zamazon/globals.dart';
import 'dart:math';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/views/ProductPage.dart';
import 'package:zamazon/models/themeBLoC.dart';
import 'package:provider/provider.dart';

// helper function, to create a big banner for a randomly featured item.

class FeaturedItemWidget extends StatelessWidget {
  const FeaturedItemWidget({Key? key, required this.productList})
      : super(key: key);

  final List<Product> productList;

  @override
  Widget build(BuildContext context) {
    final containerTheme =
        Provider.of<ThemeBLoC>(context).themeMode != ThemeMode.dark
            ? Colors.grey[900]
            : Colors.white;

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
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(product.imageUrl!),
              ),
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
