import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:zamazon/models/Product.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
        initialRating: double.parse(product.rating!),
        allowHalfRating: true,
        ignoreGestures: true,
        itemSize: 20,
        itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.orange,
            ),
        onRatingUpdate: (_) {});
  }
}
