import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zamazon/models/UserOrder.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';

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
          return Scaffold(
            appBar: AppBar(title: const Text("Order History")),
            body: Container(
              padding: const EdgeInsets.only(top: 10),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("OrderID")),
                  DataColumn(label: Text("Date")),
                  DataColumn(label: Text("Status")),
                ],
                rows: snapshot.data!
                    .map((UserOrder userOrder) => DataRow(cells: [
                          DataCell(Text(
                            userOrder.docRef!.id.substring(0, 3),
                            overflow: TextOverflow.ellipsis,
                          )),
                          DataCell(Text(
                            userOrder.orderedOn!
                                .toDate()
                                .toString()
                                .substring(0, 10),
                            overflow: TextOverflow.ellipsis,
                          )),
                          DataCell(Row(
                            children: [
                              // did not implement the actual delivered/en route feature by timing it
                              Text(
                                userOrder.delivered! ? "Delivered" : "En Route",
                                overflow: TextOverflow.ellipsis,
                              ),
                              userOrder.delivered!
                                  ? Container()
                                  : IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, "/OrderTrackMap");
                                      },
                                      icon: const Icon(Icons.map))
                            ],
                          )),
                        ]))
                    .toList(),
              ),
            ),
          );
        });
  }

  String getDate(Timestamp timestamp) {
    DateTime dateTime = DateTime.parse(timestamp.toDate().toString());
    print(dateTime.toString());
    return dateTime.toString();
  }
}
