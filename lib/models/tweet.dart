// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  String tweet;
  final likes;
  String uid;
  DateTime datePublished;
  String docId;

  Tweet({
    required this.likes,
    required this.tweet,
    required this.uid,
    required this.datePublished,
    required this.docId,
  });

  static Tweet fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Tweet(
      tweet: snapshot["tweet"],
      likes: snapshot["likes"],
      uid: snapshot["uid"],
      datePublished: snapshot["datePublished"],
      docId: snapshot["docId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "tweet": tweet,
        "likes": likes,
        "uid": uid,
        "datePublished": datePublished,
        "docId": docId
      };
}
