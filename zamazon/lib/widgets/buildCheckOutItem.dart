import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';

import '../models/themeBLoC.dart';

class BuildCheckOutItem extends StatelessWidget {
  const BuildCheckOutItem({
    super.key,
    required this.scwlItem,
  });

  final ShoppingCartWishListItem scwlItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Provider.of<ThemeBLoC>(context).themeMode == ThemeMode.dark
            ? Colors.grey[900]
            : Colors.orange[100],
      ),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                scwlItem.imageUrl!,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${scwlItem.title}",
                  style: const TextStyle(fontSize: 17),
                  softWrap: false,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "\$${scwlItem.totalPrice}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                scwlItem.size != 0
                    ? Text.rich(TextSpan(children: [
                      TextSpan(
                            text: FlutterI18n.translate(context, "BuildCheckOutItem.size"),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: "${scwlItem.size}",
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ]))
                    : Container(
                        height: 0,
                      ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Qty: ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: scwlItem.quantity.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
