import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';

class ProceedToCheckOutWidget extends StatelessWidget {
  const ProceedToCheckOutWidget({Key? key, required this.checkOutItems})
      : super(key: key);

  final List<ShoppingCartWishListItem> checkOutItems;

  @override
  Widget build(BuildContext context) {
    double cartSum = _sumOfCart(checkOutItems);
    int numOfItems = _numOfItems(checkOutItems);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
      decoration: const BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FlutterI18n.translate(context, "ProceedToCheckOut.total"),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                '\$${cartSum.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              )
            ],
          ),
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
                    'checkOutItems': checkOutItems,
                    'sumOfCart': cartSum,
                    'numOfItems': numOfItems,
                  },
                );
              },
              child: Text(
                  FlutterI18n.translate(context, "ProceedToCheckOut.proceed"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  )))
        ],
      ),
    );
  }

  double _sumOfCart(List<ShoppingCartWishListItem> items) {
    double cartSum = 0;

    for (var item in items) {
      cartSum += item.totalPrice!;
    }

    return cartSum;
  }

  int _numOfItems(List<ShoppingCartWishListItem> items) {
    int count = 0;

    for (var item in items) {
      count += item.quantity!;
    }

    return count;
  }
}
