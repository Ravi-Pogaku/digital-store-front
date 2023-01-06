import 'package:flutter/material.dart';
import 'package:zamazon/models/Product.dart';

// wrap this class around widgets that should send the user to a product's
// page on tap.

class NavigateToProductPage extends StatelessWidget {
  const NavigateToProductPage({
    super.key,
    required this.product,
    required this.child,
  });

  final Product product;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/ProductPage",
          arguments: {
            'title': 'Product',
            'product': product,
          },
        );
      },
      child: child,
    );
  }
}
