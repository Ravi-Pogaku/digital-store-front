import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/models/settings_BLoC.dart';
import 'package:zamazon/widgets/navigateToProductPage.dart';
import 'package:zamazon/widgets/priceWidget.dart';
import 'package:zamazon/widgets/productImage.dart';
import 'package:zamazon/widgets/ratingWidget.dart';

class BuildProductCarousel extends StatelessWidget {
  const BuildProductCarousel({
    super.key,
    required this.specificProducts,
  });

  final List<Product> specificProducts;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: specificProducts.length,
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.42,
      ),
      itemBuilder: (context, itemIndex, pageViewIndex) {
        double height = MediaQuery.of(context).size.height;

        return NavigateToProductPage(
          product: specificProducts[itemIndex],
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Provider.of<SettingsBLoC>(context).isDarkMode
                    ? Colors.grey[800]
                    : Colors.white),
            child: Column(
              children: [
                Flexible(
                  flex: 2,
                  child: ProductImage(
                    margin: const EdgeInsets.all(10),
                    imageFit: BoxFit.contain,
                    imageHeight: height * 0.18,
                    backgroundHeight: height * 0.2,
                    backgroundBorder: BorderRadius.circular(20),
                    imageUrl: specificProducts[itemIndex].imageUrl!,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      "${specificProducts[itemIndex].title}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                RatingWidget(rating: specificProducts[itemIndex].rating!),
                PriceWidget(price: specificProducts[itemIndex].price!),
              ],
            ),
          ),
        );
      },
    );
  }
}
