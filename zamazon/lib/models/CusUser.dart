import 'package:cloud_firestore/cloud_firestore.dart';

// class for managing and manipulating the user's personal information.

class CusUser {
  DocumentReference? docRef;
  String? name;
  String? address;
  String? email;

  // Only for the streambuilder to have initialdata while the stream initializes
  CusUser({
    this.name = 'Default',
    this.email = 'default@default.com',
    this.address = 'defaultAddress',
  });

  CusUser.fromMap(var map, {this.docRef}) {
    this.name = map['name'];
    this.email = map['email'];
    this.address = map['address'];
  }

  Map<String, Object?> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'address' : this.address,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return '$name, $email, $address';
  }
}
