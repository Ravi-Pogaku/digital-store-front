import 'package:cloud_firestore/cloud_firestore.dart';

// data class for setting up a user's purchasedProducts

class UserOrder {
  DocumentReference? docRef;
  bool? delivered;
  Timestamp? orderedOn;
  List? purchasedProducts;

  UserOrder({this.delivered, this.orderedOn, this.purchasedProducts});

  // from firestore
  UserOrder.fromMap(Map map, {required this.docRef}) {
    // print(map);
    this.delivered = map['delivered'];
    this.orderedOn = map['orderedOn'];
    this.purchasedProducts = map['purchasedProducts'];
  }

  // to firestore
  Map<String, Object?> toMap() {
    return {
      'delivered': this.delivered,
      'orderedOn': this.orderedOn,
      'purchasedProducts': this.purchasedProducts,
    };
  }

  @override
  String toString() {
    return 'Order{delivered: $delivered, orderedOn: $orderedOn, purchasedProducts: $purchasedProducts}';
  }
}
