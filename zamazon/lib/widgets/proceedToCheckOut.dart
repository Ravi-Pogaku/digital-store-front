import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';

import '../models/themeBLoC.dart';

class ProceedToCheckOutWidget extends StatefulWidget {
  ProceedToCheckOutWidget({Key? key, required this.checkOutItems})
      : super(key: key);

  List<ShoppingCartWishListItem> checkOutItems;

  @override
  State<ProceedToCheckOutWidget> createState() =>
      _ProceedToCheckOutWidgetState();
}

class _ProceedToCheckOutWidgetState extends State<ProceedToCheckOutWidget> {
  @override
  Widget build(BuildContext context) {
    double cartSum = _sumOfCart(widget.checkOutItems);
    int numOfItems = _numOfItems(widget.checkOutItems);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
      // height: MediaQuery.of(context).size.height/3,
      decoration: const BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
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
              // TODO : implement checkout button
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

  double _sumOfCart(List<ShoppingCartWishListItem> items) {
    double total = 0.0;

    for (var item in items) {
      total += item.totalPrice!;
    }

    return total;
  }

  int _numOfItems(List<ShoppingCartWishListItem> items) {
    int total = 0;

    for (var item in items) {
      total += item.quantity!;
    }

    return total;
  }
}
