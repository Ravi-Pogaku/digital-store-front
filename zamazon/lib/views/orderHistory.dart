import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
  var orderHistoryStream = SCWLModel().getUserOrderHistory();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder<List<UserOrder>>(
        initialData: const [],
        stream: orderHistoryStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            return Scaffold(
              appBar: DefaultAppBar(
                title: Text(
                    FlutterI18n.translate(context, "SettingPage.order_hist")),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              body: DataTable(
                columnSpacing: 0,
                columns: [
                  DataColumn(
                      label: SizedBox(
                          width: width * 0.2,
                          child: Text(FlutterI18n.translate(
                              context, "OrderHistory.order_id"),))),
                  DataColumn(
                      label: SizedBox(
                          width: width * 0.2,
                          child: Text(FlutterI18n.translate(
                              context, "OrderHistory.items")))),
                  DataColumn(
                      label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Text(FlutterI18n.translate(
                              context, "OrderHistory.ordered_on")))),
                  DataColumn(
                      label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(FlutterI18n.translate(
                              context, "OrderHistory.delivered_on")))),
                ],
                rows: snapshot.data!
                    .map((UserOrder userOrder) => DataRow(cells: [
                          DataCell(SizedBox(
                            width: width * 0.12,
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
                              child: Text(
                                FlutterI18n.translate(
                                    context, "OrderHistory.view_all"),
                                style: const TextStyle(
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
            child: CircularProgressIndicator.adaptive(),
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
