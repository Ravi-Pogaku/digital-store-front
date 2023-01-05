import 'package:flutter/material.dart';
import 'package:zamazon/models/settings_BLoC.dart';
import 'package:zamazon/widgets/defaultAppBar.dart';
import 'package:zamazon/models/Product.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/widgets/navigateToProductPage.dart';
import 'package:zamazon/widgets/productImage.dart';
import 'package:zamazon/widgets/ratingWidget.dart';
import 'package:zamazon/widgets/priceWidget.dart';

class ViewAllCategoryProducts extends StatelessWidget {
  const ViewAllCategoryProducts({
    super.key,
    required this.title,
    required this.specificProducts,
  });

  final String title;
  final List<Product> specificProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: Text(title),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1 / 1.8,
        ),
        itemCount: specificProducts.length,
        itemBuilder: (BuildContext context, int index) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;

          return NavigateToProductPage(
            product: specificProducts[index],
            child: Card(
              color: Provider.of<SettingsBLoC>(context).isDarkMode
                  ? Colors.grey[800]
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              child: Column(
                children: [
                  ProductImage(
                    margin: const EdgeInsets.all(10),
                    backgroundBorder: BorderRadius.circular(20),
                    imageHeight: height * 0.16,
                    imageWidth: width * 0.4,
                    backgroundHeight: height * 0.2,
                    backgroundWidth: width * 0.42,
                    imageFit: BoxFit.contain,
                    imageUrl: specificProducts[index].imageUrl!,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "${specificProducts[index].title}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  RatingWidget(rating: specificProducts[index].rating!),
                  PriceWidget(price: specificProducts[index].price!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
