import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

// class for creating and authenticating user's of our app

class Auth {
  final _auth = FirebaseAuth.instance;

  // firebase authenticating user signing
  Future signIn(String? email, String? password) async {
    await _auth.signInWithEmailAndPassword(email: email!, password: password!);
    print('SIGNED IN');
  }

  // firebase creating and authenticating new users
  Future signUp(String? email, String? password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email!, password: password!);

    print('SIGNED UP');
  }

  // add user's personal info to a document with the same id as the user's account
  Future addUserInfo(String name, String address) async {
    User currUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('users').doc(currUser.uid).set({
      'name': name,
      'email': currUser.email,
      'address' : address
    });

    print('ADDED USER INFO TO DOC');
  }

  //signout the current user
  Future signOut() async {
    await _auth.signOut();
    print('LOGGED OUT');
  }
}
