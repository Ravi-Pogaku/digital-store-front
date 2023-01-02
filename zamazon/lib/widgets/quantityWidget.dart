import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
import '../models/settings_BLoC.dart';

// creates the + and -  buttons to modify an item's quantity in your shopping
// cart.

class QuantityWidget extends StatelessWidget {
  const QuantityWidget({super.key, required this.scwlItem});

  final ShoppingCartWishListItem scwlItem;

  @override
  Widget build(BuildContext context) {
    final buttonTheme =
        Provider.of<SettingsBLoC>(context).themeMode == ThemeMode.dark
            ? Colors.white
            : Colors.black;

    return Row(
      children: [
        // minus button
        OutlinedButton(
            onPressed: () {
              if (scwlItem.quantity! > 1) {
                scwlItem.quantity = scwlItem.quantity! - 1;
                scwlItem.totalPrice =
                    scwlItem.pricePerUnit! * scwlItem.quantity!;
                SCWLModel().updateCartWishList(scwlItem);
              }
            },
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              foregroundColor: buttonTheme,
            ),
            child: const Icon(Icons.remove)),

        // current quantity of product in your cart
        Text("Qty: ${scwlItem.quantity}"),

        // add button
        OutlinedButton(
            onPressed: () {
              if (scwlItem.quantity! < 99) {
                scwlItem.quantity = scwlItem.quantity! + 1;
                scwlItem.totalPrice =
                    scwlItem.pricePerUnit! * scwlItem.quantity!;
                SCWLModel().updateCartWishList(scwlItem);
              }
            },
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              foregroundColor: buttonTheme,
            ),
            child: const Icon(Icons.add)),
      ],
    );
  }
}
