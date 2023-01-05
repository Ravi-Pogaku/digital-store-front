import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zamazon/models/UserOrder.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';

import '../widgets/orderedItemsDialog.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserOrder>>(
        initialData: const [],
        stream: SCWLModel().getUserOrderHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text("Order History")),
              body: DataTable(
                columnSpacing: 0,
                columns: [
                  DataColumn(
                      label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: const Text("ID"))),
                  DataColumn(
                      label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: const Text("Items"))),
                  DataColumn(
                      label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: const Text("Ordered On"))),
                  DataColumn(
                      label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: const Text("Delivered On"))),
                ],
                rows: snapshot.data!
                    .map((UserOrder userOrder) => DataRow(cells: [
                          DataCell(SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Text(
                              userOrder.docRef!.id.substring(0, 3),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                          DataCell(SizedBox(
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: GestureDetector(
                              onTap: () {
                                showOrderedItemsDialog(
                                    context, userOrder.purchasedProducts!);
                              },
                              child: const Text(
                                "View All",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                              ),
                            ),
                          )),
                          DataCell(SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: createDateWidgetFromTimeStamp(
                                userOrder.orderedOn!),
                          )),
                          DataCell(SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Row(
                              children: [
                                createDateWidgetFromTimeStamp(
                                    userOrder.deliveredOn!),
                                IconButton(
                                    splashRadius: 20,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "/OrderTrackMap",
                                          arguments: {
                                            'title': 'Tracking Order',
                                            'deliveryAddress':
                                                userOrder.deliveryAddress,
                                          });
                                    },
                                    icon: const Icon(Icons.map))
                              ],
                            ),
                          )),
                        ]))
                    .toList(),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget createDateWidgetFromTimeStamp(Timestamp date) {
    return Text(
      date.toDate().toString().substring(0, 10),
      overflow: TextOverflow.ellipsis,
    );
  }
}
