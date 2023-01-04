import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/widgets/ProductCarousel.dart';
import 'package:zamazon/widgets/categoryHeader.dart';
import 'package:zamazon/widgets/navigateToProductPage.dart';
import 'package:zamazon/widgets/productImage.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/models/settings_BLoC.dart';
import 'priceWidget.dart';
import 'ratingWidget.dart';

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
        .where((product) => product.categories![0] == category)
        .toList();

    if (productList.isNotEmpty) {
      String categoryName = category[0].toUpperCase() + category.substring(1);

      return Column(
        children: [
          CategoryHeader(
            category: categoryName,
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
