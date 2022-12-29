import 'package:cloud_firestore/cloud_firestore.dart';

// Class for the items in someone's shoppingcart or wishlist.
// Only some information about the product is required for this so
// we chose to make it a new class specifically for populating the ui of
// the shopping cart and wishlist. dunno if this is a good way to do this.

class ShoppingCartWishListItem {
  DocumentReference? docRef;
  String? productId;
  String? title;
  String? imageUrl;
  int? quantity;
  int? size;
  double? pricePerUnit;
  double? totalPrice;
  List? sizeSelection;

  ShoppingCartWishListItem({
    this.docRef,
    this.productId,
    this.imageUrl,
    this.title,
    this.quantity,
    this.size,
    this.pricePerUnit,
    this.totalPrice,
    this.sizeSelection,
  });

  ShoppingCartWishListItem.fromMap(Map map, {required this.docRef}) {
    this.productId = map['productId'];
    this.title = map['title'];
    this.imageUrl = map['imageUrl'];
    this.quantity = map['quantity'];
    this.size = map['size'];
    this.pricePerUnit = map['pricePerUnit'];
    this.totalPrice = map['totalPrice'];
    this.sizeSelection = map['sizeSelection'];
  }

  Map<String, Object?> toMap() {
    return {
      'productId': this.productId,
      'title': this.title,
      'imageUrl': this.imageUrl,
      'quantity': this.quantity,
      'size': this.size,
      'pricePerUnit': this.pricePerUnit,
      'totalPrice': this.totalPrice,
      'sizeSelection': this.sizeSelection,
    };
  }

  @override
  String toString() {
    return 'ShoppingCartWishListItem{'
        'productId: $productId, '
        'title: $title, '
        'imageUrl: $imageUrl,'
        'quantity: $quantity, '
        'size: $size, '
        'pricePerUnit: $pricePerUnit, '
        'totalPrice: $totalPrice'
        'sizeSelection: $sizeSelection}';
  }
}
