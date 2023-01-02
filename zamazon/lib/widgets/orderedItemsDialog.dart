import 'package:flutter/material.dart';

import '../models/shoppingCartWishListItem.dart';
import 'buildCheckOutItem.dart';

void showOrderedItemsDialog(BuildContext context, List<dynamic> orderedItems) {
  double height = MediaQuery.of(context).size.height;

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Items"),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          content: SizedBox(
            height: (orderedItems.length < 3) ? height/4 : height,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
                itemCount: orderedItems.length,
                itemBuilder: (context, index) {
                  return BuildCheckOutItem(
                      scwlItem: ShoppingCartWishListItem(
                        title: orderedItems[index]['title'],
                        imageUrl: orderedItems[index]['imageUrl'],
                        productId: orderedItems[index]['productId'],
                        quantity: orderedItems[index]['quantity'],
                        size: orderedItems[index]['size'],
                        pricePerUnit: orderedItems[index]['pricePerUnit'],
                        totalPrice: orderedItems[index]['totalPrice'],
                        sizeSelection: orderedItems[index]['sizeSelection'],
                      )
                  );
                }),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 20.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close")
              ),
            ),
          ],
        );
      }
  );
}