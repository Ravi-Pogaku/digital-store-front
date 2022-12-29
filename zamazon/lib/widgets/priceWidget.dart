import 'package:flutter/material.dart';
import '../models/Product.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({Key? key, required this.price}) : super(key: key);

  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      // ${product!.savings!.substring(18,21)}
      child: Text("\$$price", style: const TextStyle(fontSize: 25)),
    );
  }
}
