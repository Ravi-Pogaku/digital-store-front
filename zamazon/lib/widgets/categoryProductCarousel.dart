import 'package:flutter/material.dart';
import 'package:zamazon/widgets/productCarousel.dart';
import 'package:zamazon/widgets/categoryHeader.dart';
import 'package:zamazon/models/Product.dart';

// Carousel slider product display on homepage

class CategoryProductCarousel extends StatelessWidget {
  const CategoryProductCarousel({
    super.key,
    required this.productList,
    required this.category,
  });

  final List<Product> productList;
  final String category;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // the specific products of the current category
    final specificProducts = productList
        .where((product) => product.categories![0] == category.toLowerCase())
        .toList();

    if (productList.isNotEmpty) {
      return Column(
        children: [
          CategoryHeader(
            category: category,
            specificProducts: specificProducts,
          ),
          BuildProductCarousel(
            specificProducts: specificProducts,
          ),
        ],
      );
    } else {
      return SizedBox(
        height: height * 0.15,
        child: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }
  }
}
