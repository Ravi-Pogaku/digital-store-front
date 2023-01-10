import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

// creates the stars of a product based on a rating out of 5.

class RatingWidget extends StatelessWidget {
  const RatingWidget({Key? key, required this.rating}) : super(key: key);

  final String rating;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
        initialRating: double.parse(rating),
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
