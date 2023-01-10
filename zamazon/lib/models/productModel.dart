import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zamazon/models/Product.dart';

class ProductModel {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Returns a stream containing the list of all products in firestore
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      //
      return snapshot.docs.map((document) {
        //
        return Product.fromMap(document.data(), docRef: document.reference);
      }).toList();
    });
  }

  //Insert product into data, just to easily fill firestore with sample data.
  //Data is inserted when you try to add product to cart.
  //TODO USERS CAN SELL ITEMS
  Future insertProduct(Product product) async {
    await _db.collection('products').doc().set(product.toMap());
  }
}
