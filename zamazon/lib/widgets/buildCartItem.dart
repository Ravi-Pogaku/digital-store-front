import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
import 'package:zamazon/widgets/buildQuantityWidget.dart';

import '../models/themeBLoC.dart';

class BuildCartItem extends StatelessWidget {
  BuildCartItem({super.key, required this.scwlItem, required this.width});

  ShoppingCartWishListItem scwlItem;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            SCWLModel().deleteCartWishList(scwlItem);
          },
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Provider.of<ThemeBLoC>(context).themeMode == ThemeMode.dark
                  ? Colors.grey[700]
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: width - 110,
                ),
                const Icon(Icons.delete)
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    height: 125,
                    width: width / 2.5,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        scwlItem.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 5),
                      child: BuildQuantityWidget(scwlItem: scwlItem))
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${scwlItem.title}",
                      style: const TextStyle(fontSize: 17),
                      softWrap: false,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "\$${double.parse(scwlItem.totalPrice!.toStringAsFixed(2))}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    scwlItem.size != 0
                        ? Text.rich(TextSpan(children: [
                            TextSpan(
                                text: FlutterI18n.translate(
                                    context, "BuildCartItem.size"),
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: "${scwlItem.size}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ]))
                        : Container(
                            height: 0,
                          ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
