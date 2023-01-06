import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/Product.dart';
import 'featuredItemWidget.dart';
import 'categoryProductCarousel.dart';
import 'package:zamazon/globals.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody>
    with AutomaticKeepAliveClientMixin {
  List<Product> products = [];
  final int randomCategory = Random().nextInt(categories.length - 2);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    products = Provider.of<List<Product>>(context);

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
