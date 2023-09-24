import 'package:flutter/material.dart';

import '../models/user.dart';

class TypeProvdier with ChangeNotifier {
  User user = User(
      email: "",
      uid: "",
      photoUrl: "G",
      username: "",
      bio: "",
      followers: [],
      following: [],
      matched: []);

  void hearing() {
    notifyListeners();
  }

  User createUser() {
    return User(
        email: "",
        uid: "",
        photoUrl: "G",
        username: "",
        bio: "",
        followers: [],
        following: [],
        matched: []);
  }

  User userx = User(
      email: "",
      uid: "sda",
      photoUrl:
          "https://media.istockphoto.com/id/1472932742/photo/group-of-multigenerational-people-hugging-each-others-support-multiracial-and-diversity.jpg?s=2048x2048&w=is&k=20&c=9Ne4TeztjZq2EEeN1mOyiMxmJwiJgpzrlumR8T-OplA=",
      username: "Loading...",
      bio: "Loading...",
      followers: [],
      following: [],
      matched: []);

  bool chatlistflaging = false;

  bool isAnonymous = false;
  bool chatlistflag1 = false;
  List<dynamic> messages = [];

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
