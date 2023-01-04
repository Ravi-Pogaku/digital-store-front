import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/Product.dart';
import 'featuredItemWidget.dart';
import 'productViewWidget.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  static const categories = [
    'electronics',
    'computer',
    'kitchen',
    'video games',
    'clothes',
    'cosmetics',
    'game console',
    'shoes',
  ];

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<List<Product>>(context);
    int randomCategory = Random().nextInt(categories.length);

    // randomly take a slice of 3 categories from the category list.
    while (randomCategory + 2 > 7) {
      randomCategory = Random().nextInt(8);
    }

    if (products.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          //random featured item
          FeaturedItemWidget(
            productList: products,
          ),

          //horizontal listview of products of different categories
          CategoryProductCarousel(
            productList: products,
            category: categories[randomCategory],
          ),
          CategoryProductCarousel(
            productList: products,
            category: categories[randomCategory + 1],
          ),
          CategoryProductCarousel(
            productList: products,
            category: categories[randomCategory + 2],
          ),
        ],
      ),
    );
  }
}
