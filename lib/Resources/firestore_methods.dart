import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramclone/Resources/storage_methods.dart';
import 'package:instagramclone/models/post.dart';
import 'package:instagramclone/models/tweet.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/typePro.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //upload post

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage, bool isAnonymous) async {
    late String collection;
    String res = "some error occurred";
    try {
      if (isAnonymous) {
        collection = "AnonymousPost";
      } else {
        collection = 'posts';
      }
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage);
      _firestore.collection(collection).doc(postId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likesPost(
      String postId, String uid, List likes, bool anon) async {
    String collectionName;
    if (anon) {
      collectionName = "AnonymousPost";
    } else {
      collectionName = "posts";
    }
    if (likes.contains(uid)) {
      await _firestore.collection(collectionName).doc(postId).update(
        {
          'likes': FieldValue.arrayRemove([uid])
        },
      );
    } else {
      await _firestore.collection(collectionName).doc(postId).update(
        {
          'likes': FieldValue.arrayUnion([uid])
        },
      );
    }
  }

  Future<String> postComments(String postId, String text, String uid,
      String name, String profilePic) async {
    String res;
    try {
      res = 'commented';
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
      res = e.toString();
    }
    return res;
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List liked = (snap.data()! as dynamic)['following'];

      List<String> likedBy = List<String>.from(snap['followers']);

      if (liked.contains(followId)) {
        //print("con");
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
        print(followId);
        print(likedBy[0]);
        if (likedBy.contains(followId)) {
          await FirebaseFirestore.instance
              .collection("chats")
              .doc(uid + followId)
              .set({
            "uid": [uid, followId],
            "docId": uid + followId,
            "Chat": FieldValue.arrayUnion([
              {
                "chatData": "Hey, we matched",
                "datetime": DateTime.now(),
                "uid": FirebaseAuth.instance.currentUser!.uid,
                "photoUrl": ""
              }
            ])
          });

          return true;
        }
      }

      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> uploadTweets(
    String tweet,
  ) async {
    String docId = const Uuid().v1();
    Tweet t = Tweet(
        tweet: tweet,
        likes: [],
        uid: FirebaseAuth.instance.currentUser!.uid,
        datePublished: DateTime.now(),
        docId: docId);

    try {
      await _firestore.collection("AnonymousTweets").doc(docId).set(t.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likesTweet(String tweetId, String uid, List likes) async {
    String collectionName = "AnonymousTweets";

    if (likes.contains(uid)) {
      await _firestore.collection(collectionName).doc(tweetId).update(
        {
          'likes': FieldValue.arrayRemove([uid])
        },
      );
    } else {
      await _firestore.collection(collectionName).doc(tweetId).update(
        {
          'likes': FieldValue.arrayUnion([uid])
        },
      );
    }
  }
}
