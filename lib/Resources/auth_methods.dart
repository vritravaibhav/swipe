import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagramclone/Resources/storage_methods.dart';
import 'package:instagramclone/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<model.User> getUser(String uid) async {
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
    return model.User.fromSnap(snap);
  }

  // ignore: non_constant_identifier_names
  Future<String> SignUpUser(
      {required String email,
      required String password,
      required String username,
      required String? bio,
      required Uint8List? file}) async {
    String res = "Some Error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty
          // bio.isNotEmpty ||
          // file.isNotEmpty
          ) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // print(cred.user!.uid);
        String photoUrl = "";
        if (file != null) {
          photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);
        }

        model.User user = model.User(
            email: email,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            username: username,
            bio: bio!,
            followers: [],
            following: []);
        //var m = user.toJson();

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "Success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all feeds";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().disconnect();
  }

  Future<String> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential cred =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // String photoUrl = await StorageMethods()
    //     .uploadImageToStorage('profilePics', file, false);

    User? googlesUser = cred.user;
    model.User user = model.User(
        email: googlesUser!.email.toString(),
        uid: cred.user!.uid,
        photoUrl: googlesUser.photoURL.toString(),
        username: googlesUser.displayName.toString(),
        bio: "",
        followers: [],
        following: []);
    //var m = user.toJson();

    try {
      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .update({"uid": cred.user!.uid});
    } catch (e) {
      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());
    }

    return "good";
  }
}
