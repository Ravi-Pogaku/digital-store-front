import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../models/Product.dart';
import '../models/settings_BLoC.dart';
import 'priceWidget.dart';
import 'ratingWidget.dart';

// Carousel slider product display on homepage

class ProductViewWidget extends StatelessWidget {
  const ProductViewWidget({
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
          categoryHeader(categoryName, specificProducts, context),
          productListView(category, specificProducts, height),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget categoryHeader(
      String category, List<Product> specificProducts, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      decoration: const BoxDecoration(color: Colors.orangeAccent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/CategoryPage",
                  arguments: {
                    'title': 'Category: $category',
                    'specificProducts': specificProducts,
                  },
                );
              },
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget productListView(
      String category, List<Product> specificProducts, double height) {
    return CarouselSlider.builder(
      itemCount: specificProducts.length,
      options: CarouselOptions(
        height: height * 0.4,
      ),
      itemBuilder: (context, itemIndex, pageViewIndex) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              "/ProductPage",
              arguments: {
                'title': 'Product',
                'product': specificProducts[itemIndex],
              },
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Provider.of<SettingsBLoC>(context).isDarkMode
                    ? Colors.grey[800]
                    : Colors.white),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            specificProducts[itemIndex].imageUrl!,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    "${specificProducts[itemIndex].title}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                RatingWidget(product: specificProducts[itemIndex]),
                PriceWidget(price: specificProducts[itemIndex].price!),
              ],
            ),
          ),
        );
      },
    );
  }
}
