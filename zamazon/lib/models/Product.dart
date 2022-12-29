import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  DocumentReference? docRef;
  String? id;
  String? title;
  int? numReviews;
  String? rating;
  List? sizeSelection;
  String? warehouseAvailability;
  double? price;
  String? imageUrl;
  List? categories;
  List? features; //DEFAULT
  String? productDescription; //DEFAULT
  List? productDetails; //DEFAULT

  Product({
    this.title,
    this.numReviews,
    this.rating,
    this.sizeSelection,
    this.warehouseAvailability,
    this.price,
    this.features,
    this.imageUrl,
    this.productDescription,
    this.productDetails,
    this.categories,
  });

  Product.fromMap(var map, {required this.docRef}) {
    this.id = docRef!.id;
    this.title = map['title'];
    this.numReviews = map['numReviews'];
    this.rating = map['rating'];
    this.sizeSelection = map['sizeSelection'];
    this.warehouseAvailability = map['warehouseAvailability'];
    this.price = map['price'];
    this.features = map['features'];
    this.imageUrl = map['imageUrl'];
    this.productDescription = map['productDescription'];
    this.productDetails = map['productDetails'];
    this.categories = map['categories'];
  }

  Product.fromScrapedMap(var map) {
    this.title = map['title'];
    this.numReviews = map['numReviews'];
    this.rating = map['rating'];
    this.sizeSelection = map['sizeSelection'];
    this.warehouseAvailability = map['warehouseAvailability'];
    this.price = map['price'];
    this.imageUrl = map['imageUrl'];
    this.categories = map['categories'];

    // DEFAULTS CUZ IM BAD AT HTML, I DONT KNOW HOW TO SCRAPE THIS INFO :)
    this.features = ['Premium SOLID Stainless Steel'];
    this.productDescription =
        'PS4 Pro 4K TV GAMING & MORE The most advanced PlayStation system ever. PS4 Pro is designed to take your favorite PS4 games and add to them with more power for graphics';
    this.productDetails = [
      {
        'name': 'Item Weight',
        'value': '2.46 Kg',
      },
      {
        'name': 'Bestsellers Rank',
        'value':
            '392,852 in Home & Kitchen (See Top 100 in Home & Kitchen) #336 in Dinner Sets',
      },
    ];
  }

  Map<String, Object?> toMap() {
    return {
      'title': this.title,
      'numReviews': this.numReviews,
      'rating': this.rating,
      'sizeSelection': this.sizeSelection,
      'warehouseAvailability': this.warehouseAvailability,
      'price': this.price,
      'features': this.features,
      'imageUrl': this.imageUrl,
      'productDescription': this.productDescription,
      'productDetails': this.productDetails,
      'categories': this.categories,
    };
  }

  @override
  String toString() {
    return 'Product{ \n'
        'title: $title, \n'
        'numReviews: $numReviews, \n'
        'rating: $rating, \n'
        'sizeSelection: $sizeSelection, \n'
        'warehouseAvailability: $warehouseAvailability, \n'
        'price: $price, \n'
        'features: $features, \n'
        'imageUrl: $imageUrl, \n'
        'productDescription: $productDescription, \n'
        'productDetails: $productDetails, \n'
        'categories: $categories, \n';
  }
}
