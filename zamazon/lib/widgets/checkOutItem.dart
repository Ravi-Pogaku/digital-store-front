import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'package:zamazon/widgets/productImage.dart';

import '../models/settings_BLoC.dart';

class BuildCheckOutItem extends StatelessWidget {
  const BuildCheckOutItem({
    super.key,
    required this.scwlItem,
  });

  final ShoppingCartWishListItem scwlItem;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Provider.of<SettingsBLoC>(context).isDarkMode
            ? Colors.grey[900]
            : Colors.orange[100],
      ),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        children: [
          ProductImage(
            imageWidth: width * 0.4,
            imageHeight: height * 0.2,
            backgroundWidth: width * 0.42,
            backgroundHeight: height * 0.22,
            border: BorderRadius.circular(20),
            imageFit: BoxFit.contain,
            imageUrl: scwlItem.imageUrl!,
          ),
          SizedBox(
            width: width * 0.05,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${scwlItem.title}",
                  style: const TextStyle(fontSize: 17),
                  softWrap: false,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "\$${scwlItem.totalPrice}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                scwlItem.size != 0
                    ? Text.rich(TextSpan(children: [
                        TextSpan(
                            text: FlutterI18n.translate(
                                context, "BuildCheckOutItem.size"),
                            style: const TextStyle(
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
