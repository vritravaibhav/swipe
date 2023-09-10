import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TypeProvdier with ChangeNotifier {
  bool isAnonymous = false;
   List<dynamic> messages=[];

  Future<void> vaibhav() async {
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc("GlobalChat")
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.exists) {

    //     x = documentSnapshot.data();
    //     _messages = x["Chat"];
    //     //  _messages.sort((a, b) => a["datetime"].compareTo(b["dateTime"]));

    //   }

    // });

   
  }
}
