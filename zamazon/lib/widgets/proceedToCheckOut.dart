import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';

import '../models/settings_BLoC.dart';

class ProceedToCheckOutWidget extends StatefulWidget {
  const ProceedToCheckOutWidget({Key? key, required this.checkOutItems})
      : super(key: key);

  final List<ShoppingCartWishListItem> checkOutItems;

  @override
  State<ProceedToCheckOutWidget> createState() =>
      _ProceedToCheckOutWidgetState();
}

class _ProceedToCheckOutWidgetState extends State<ProceedToCheckOutWidget> {
  double cartSum = 0.0;
  int numOfItems = 0;

  @override
  Widget build(BuildContext context) {
    _sumAndNumOfCart(widget.checkOutItems);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
      decoration: const BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              FlutterI18n.translate(context, "ProceedToCheckOut.total"),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              '\$${cartSum.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            )
          ]),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fixedSize: Size(width - 100, 40),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/CheckOut',
                  arguments: {
                    'title': 'Checkout',
                    'checkOutItems': widget.checkOutItems,
                    'sumOfCart': cartSum,
                    'numOfItems': numOfItems,
                  },
                );
              },
              child: Text(
                  FlutterI18n.translate(context, "ProceedToCheckOut.proceed"),
                  style: const TextStyle(color: Colors.white)))
        ],
      ),
    );
  }

  void _sumAndNumOfCart(List<ShoppingCartWishListItem> items) {
    cartSum = 0;
    numOfItems = 0;

    for (var item in items) {
      cartSum += item.totalPrice!;
      numOfItems += item.quantity!;
    }
  }
}
