import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamazon/models/CusUser.dart';

//TODO
// MAKE PROFILE PAGE WHERE USER CAN UPDATE THEIR INFORMATION
// MAKE FUNCTIONS THAT WILL UPDATE CHANGED INFORMATION.

// model class to retrieve user information: name, email, address.
// information will be displayed and can be updated in profile page.

class UserModel {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Stream the current user's personal information.
  Stream<CusUser> getUserInformation() {
    User? currUser = _auth.currentUser;

    return _db
        .collection('users')
        .doc(currUser!.uid)
        .snapshots()
        .map((docSnap) {
      return CusUser.fromMap(docSnap.data());
    });
  }
}
