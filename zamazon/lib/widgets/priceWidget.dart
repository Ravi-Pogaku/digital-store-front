import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({Key? key, required this.price}) : super(key: key);

  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Text(
        "\$${price.toStringAsFixed(2)}",
        style: const TextStyle(fontSize: 25),
      ),
    );
  }
}
