import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/models/bottomNavBarBLoC.dart';
import 'package:zamazon/models/productModel.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
import 'package:zamazon/widgets/addToShoppingCartButton.dart';
import 'package:zamazon/widgets/addToWishListButton.dart';
import 'package:zamazon/widgets/defaultAppBar.dart';
import 'package:zamazon/widgets/productImage.dart';
import 'package:zamazon/widgets/ratingWidget.dart';
import 'package:zamazon/widgets/priceWidget.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/globals.dart';

// When a product is tapped, user will be navigated to its respective
// page. This class is responsible for creating that page. From here, user's can
// add products to their shopping cart/wish list.

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, this.title, required this.product})
      : super(key: key);

  final String? title;
  final Product product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Product? product;

  static const TextStyle headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  static const TextStyle largerStyle = TextStyle(fontSize: 20);
  static const TextStyle regularStyle = TextStyle(fontSize: 17);

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  ProductModel productModel = ProductModel();
  final SCWLModel _scwlModel = SCWLModel();

  // TODO: let users rate product?

  @override
  Widget build(BuildContext context) {
    // for back to top button
    ScrollController scrollController = ScrollController();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    int currentPageNum = Provider.of<BottomNavBarBLoC>(context).currentPageNum;
    Color foregroundColor = (currentPageNum == 0) ? Colors.black : Colors.white;

    return Scaffold(
      appBar: DefaultAppBar(
        backgroundColor: barBGColors[currentPageNum],
        foregroundColor: foregroundColor,
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate(
            [
              // STARS AND NUM OF REVIEWS
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // creates star rating widget
                    // requires to be run with "flutter run --no-sound-null-safety"
                    RatingWidget(rating: product!.rating!),
                    Text(
                      "(${product!.numReviews})",
                      style: largerStyle,
                    ),
                  ],
                ),
              ),

              // PRODUCT NAME
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    "${product!.title}",
                    style: largerStyle,
                  )),

              const SizedBox(height: 10),

              ProductImage(
                imageHeight: height * 0.4,
                backgroundWidth: width,
                backgroundHeight: height * 0.45,
                imageUrl: product!.imageUrl!,
              ),

              const SizedBox(height: 10),

              // Price of product
              PriceWidget(price: product!.price!),

              // Warehouse Availability, i.e. 'In Stock' or 'Only 3 left in stock.', etc.
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "${product!.warehouseAvailability}",
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                ),
              ),

              // Add to cart and add to wishlist buttons
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                AddToCartButton(
                  product: product!,
                  scwlModel: _scwlModel,
                ),
                AddToWishListButton(
                  product: product!,
                  scwlModel: _scwlModel,
                ),
              ]),

              const Divider(
                height: 50,
                thickness: 2,
              ),

              // Product Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      FlutterI18n.translate(context, "ProductPage.detail"),
                      style: headerStyle,
                    ),
                  ),
                  // looping through productDetails and
                  // creating a row for each product detail
                  for (Map detail in product!.productDetails!)
                    (Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "${detail['name']}",
                                style: regularStyle,
                              )),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        Flexible(
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "${detail['value']}",
                                  style: regularStyle,
                                )))
                      ],
                    ))
                ],
              ),

              const Divider(
                height: 30,
                thickness: 2,
              ),

              // Product description
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Text(
                    FlutterI18n.translate(context, "ProductPage.description"),
                    style: headerStyle,
                  )),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "${product!.productDescription}",
                    style: regularStyle,
                  )),

              const Divider(
                height: 30,
                thickness: 2,
              ),

              // Product features
              Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Text(
                  FlutterI18n.translate(context, "ProductPage.feature"),
                  style: headerStyle,
                ),
              ),
              for (String feature in product!.features!)
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    '• $feature',
                    style: regularStyle,
                  ),
                ),

              // button that scrolls back to top of page
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(width, 50),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      backgroundColor: barBGColors[currentPageNum]),
                  onPressed: () {
                    scrollController.animateTo(0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.decelerate);
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.keyboard_double_arrow_up,
                        color: foregroundColor,
                      ),
                      Text(
                        FlutterI18n.translate(
                            context, "ProductPage.back_to_top"),
                        style: TextStyle(color: foregroundColor),
                      ),
                    ],
                  ))
            ],
          ))
        ],
      ),
    );
  }
}
