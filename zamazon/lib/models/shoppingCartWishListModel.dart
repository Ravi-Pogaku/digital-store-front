//SHOPPING CART WISH LIST MODEL
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'package:zamazon/models/Product.dart';
import '../globals.dart';
import 'userOrder.dart';
import 'package:timezone/timezone.dart' as tz;

// class that interacts with the user's shopping cart and wishlist on firestore

class SCWLModel {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<ShoppingCartWishListItem>> getUserShoppingCartWishList(
      String collName) {
    // collNames are either shoppingCart or wishList
    return _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection(collName)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((document) {
        return ShoppingCartWishListItem.fromMap(document.data(),
            docRef: document.reference);
      }).toList();
    });
  }

  Future<void> addToCartWishList(Product product, String collName,
      {int size = 1}) async {
    ShoppingCartWishListItem scwlItem = ShoppingCartWishListItem(
      title: product.title,
      imageUrl: product.imageUrl,
      productId: product.id,
      quantity: 1,
      size: size,
      pricePerUnit: product.price,
      totalPrice: product.price,
      sizeSelection: product.sizeSelection,
    );

    var collRef = _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection(collName);
    var doc = await collRef.doc('${product.id}${scwlItem.size}').get();

    // if the product of the same size is in the shopping cart, then just increment
    // the quantity value of that item instead of adding a new document.
    if (collName == 'shoppingCart' && doc.exists) {
      await _db
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection(collName)
          .doc('${product.id}${scwlItem.size}')
          .update({
        'quantity': FieldValue.increment(1),
        'totalPrice': FieldValue.increment(scwlItem.pricePerUnit!),
      });
    } else {
      await _db
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection(collName)
          .doc(collName == "wishList"
              ? product.id
              : '${product.id}${scwlItem.size}')
          .set(scwlItem.toMap());
    }
  }

  Stream<List<UserOrder>> getUserOrderHistory() {
    return _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('orders')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((document) {
        return UserOrder.fromMap(document.data(), docRef: document.reference);
      }).toList();
    });
  }

  Future<void> addToOrderHistory(
      List<ShoppingCartWishListItem> checkedOutItems,
      String userAddress,
      tz.TZDateTime orderDate,
      tz.TZDateTime deliveryDate) async {
    List<Map> mappedSCWLItems = [];

    for (ShoppingCartWishListItem checkedOutItem in checkedOutItems) {
      mappedSCWLItems.add(checkedOutItem.toMap());
    }

    await _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection("orders")
        .doc()
        .set({
      "deliveryAddress": userAddress,
      "warehouseAddress": Constants.warehouseAddress,
      "deliveredOn": deliveryDate,
      "orderedOn": orderDate,
      "purchasedProducts": FieldValue.arrayUnion(mappedSCWLItems),
    }, SetOptions(merge: true));

    await _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection("shoppingCart")
        .get()
        .then((value) {
      for (var document in value.docs) {
        document.reference.delete();
      }
    });
  }

  Future<void> updateCartWishListItem(ShoppingCartWishListItem scwlItem) async {
    await scwlItem.docRef!.update(scwlItem.toMap());
  }

  // delet
  Future<void> deleteCartWishListItem(ShoppingCartWishListItem scwlItem) async {
    await scwlItem.docRef!.delete();
  }

  // empty the user's shoppingCart or wishList
  Future<void> deleteAllCartWishList(String collName) async {
    await _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection(collName)
        .get()
        .then((value) {
      for (var document in value.docs) {
        document.reference.delete();
      }
    });
  }

  Future<Product> getProduct(String productId) async {
    return await _db.collection('products').doc(productId).get().then((value) {
      return Product.fromMap(value.data(), docRef: value.reference);
    });
  }
}
