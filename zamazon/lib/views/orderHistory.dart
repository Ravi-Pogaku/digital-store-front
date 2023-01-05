import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zamazon/models/userOrder.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';
import 'package:zamazon/widgets/defaultAppBar.dart';
import 'package:zamazon/widgets/orderedItemsDialog.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder<List<UserOrder>>(
        initialData: const [],
        stream: SCWLModel().getUserOrderHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            return Scaffold(
              appBar: const DefaultAppBar(
                title: Text('Order History'),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              body: DataTable(
                columnSpacing: 0,
                columns: [
                  DataColumn(
                      label: SizedBox(
                          width: width * 0.2, child: const Text("OrderID"))),
                  DataColumn(
                      label: SizedBox(
                          width: width * 0.2, child: const Text("Items"))),
                  DataColumn(
                      label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: const Text("Date"))),
                  DataColumn(
                      label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: const Text("Status"))),
                ],
                rows: snapshot.data!
                    .map((UserOrder userOrder) => DataRow(cells: [
                          DataCell(SizedBox(
                            width: width * 0.2,
                            child: Text(
                              userOrder.docRef!.id,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                          DataCell(SizedBox(
                            width: width * 0.2,
                            child: GestureDetector(
                              onTap: () {
                                showOrderedItemsDialog(
                                    context,
                                    userOrder.docRef!.id,
                                    userOrder.purchasedProducts!);
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
                            child: Text(
                              userOrder.orderedOn!
                                  .toDate()
                                  .toString()
                                  .substring(0, 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                          DataCell(SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            child: Row(
                              children: [
                                // did not implement the actual delivered/en route feature by timing it
                                Text(
                                  userOrder.delivered!
                                      ? "Delivered"
                                      : "En Route",
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
                            ),
                          )),
                        ]))
                    .toList(),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        });
  }

  String getDate(Timestamp timestamp) {
    DateTime dateTime = DateTime.parse(timestamp.toDate().toString());
    print(dateTime.toString());
    return dateTime.toString();
  }
}
