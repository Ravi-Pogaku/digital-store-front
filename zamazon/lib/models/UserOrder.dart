import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrder {
  DocumentReference? docRef;
  Timestamp? deliveredOn;
  Timestamp? orderedOn;
  List? purchasedProducts;
  String? deliveryAddress;
  String? warehouseAddress;

  UserOrder({this.deliveredOn, this.orderedOn, this.purchasedProducts});

  UserOrder.fromMap(Map map, {required this.docRef}) {
    // print(map);
    this.deliveredOn = map['deliveredOn'];
    this.orderedOn = map['orderedOn'];
    this.purchasedProducts = map['purchasedProducts'];
    this.deliveryAddress = map['deliveryAddress'];
    this.warehouseAddress = map['warehouseAddress'];
  }

  Map<String, Object?> toMap() {
    return {
      'deliveredOn': this.deliveredOn,
      'orderedOn': this.orderedOn,
      'purchasedProducts': this.purchasedProducts,
      'warehouseAddress': this.warehouseAddress,
      'deliveryAddress': this.deliveryAddress,
    };
  }

  @override
  String toString() {
    return 'UserOrder{docRef: $docRef, deliveredOn: $deliveredOn, '
        'orderedOn: $orderedOn, purchasedProducts: $purchasedProducts, '
        'deliveryAddress: $deliveryAddress, '
        'warehouseAddress: $warehouseAddress}';
  }
}
