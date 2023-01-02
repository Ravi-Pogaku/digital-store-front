import 'package:flutter/material.dart';
import 'package:zamazon/models/settings_BLoC.dart';
import 'package:zamazon/widgets/defaultAppBar.dart';
import 'package:zamazon/models/Product.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/widgets/ratingWidget.dart';
import 'package:zamazon/widgets/priceWidget.dart';

class ViewAllCategoryProducts extends StatelessWidget {
  const ViewAllCategoryProducts({
    super.key,
    required this.specificProducts,
  });

  final List<Product> specificProducts;

  @override
  Widget build(BuildContext context) {
    var itemHeight = MediaQuery.of(context).size.height;
    var itemWidth = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: DefaultAppBar(context),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1 / 2,
        ),
        itemCount: specificProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                "/ProductPage",
                arguments: {
                  'title': 'Product',
                  'product': specificProducts[index],
                },
              );
            },
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
                              specificProducts[index].imageUrl!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "${specificProducts[index].title}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
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
