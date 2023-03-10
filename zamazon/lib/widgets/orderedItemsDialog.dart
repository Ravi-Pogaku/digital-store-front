import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'checkOutItem.dart';

void showOrderedItemsDialog(
  BuildContext context,
  String orderID,
  List<dynamic> orderedItems,
) {
  double height = MediaQuery.of(context).size.height;

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '${FlutterI18n.translate(context, "OrderHistory.order_id")}: $orderID',
            softWrap: true,
            maxLines: 2,
          ),
          insetPadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            height: (orderedItems.length < 3) ? height * 0.3 : height,
            width: MediaQuery.of(context).size.width,
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
                  ));
                }),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 20.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.black),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  ),
                  child: Text(FlutterI18n.translate(context, "OrderHistory.close"))),
            ),
          ],
        );
      });
}
