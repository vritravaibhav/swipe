import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Resources/firestore_methods.dart';

// import '../models/user.dart' as model;

class TweetScreen extends StatefulWidget {
  const TweetScreen({super.key});

  @override
  State<TweetScreen> createState() => _TweetScreenState();
}

class _TweetScreenState extends State<TweetScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    //final model.User user = Provider.of<UserProvider>(context).getUser;
    CollectionReference anons =
        FirebaseFirestore.instance.collection('AnonymousTweets');
    //  print("good");

    return StreamBuilder<QuerySnapshot>(
      stream: anons.orderBy('datePublished', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      data["tweet"],
                      style: const TextStyle(
                          fontSize: 22,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            FirestoreMethods()
                                .likesTweet(data['docId'], uid, data['likes']);
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: data["likes"].contains(uid)
                                ? Colors.red
                                : Colors.white,
                          )),
                      TextButton(
                          onPressed: () {},
                          child:
                              Text("${data["likes"].length.toString()} Likes"))
                    ],
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  )
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
