import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrder {
  DocumentReference? docRef;
  bool? delivered;
  Timestamp? orderedOn;
  List? order;


  UserOrder({this.delivered, this.orderedOn, this.order});

  UserOrder.fromMap(Map map, {required this.docRef}) {
    // print(map);
    this.delivered = map['delivered'];
    this.orderedOn = map['orderedOn'];
    this.order = map['order'];
  }

  Map<String, Object?> toMap() {
    return {
      'delivered': this.delivered,
      'orderedOn': this.orderedOn,
      'order': this.order,
    };
  }

  @override
  String toString() {
    return 'Order{delivered: $delivered, orderedOn: $orderedOn, order: $order}';
  }
}