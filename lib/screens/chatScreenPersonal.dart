// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:instagramclone/Resources/auth_methods.dart';
import 'package:instagramclone/widget/receiver_row_view.dart';
import 'package:instagramclone/widget/sender_row_view.dart';

import '../models/user.dart' as model;

class ChatPagePersonal extends StatefulWidget {
  List<dynamic>? messages = [];
  final snap;
  final user;

  ChatPagePersonal({
    Key? key,
    required this.snap,
    required this.user,
  }) : super(key: key);
  @override
  _ChatPagePersonalState createState() => _ChatPagePersonalState();
}

class _ChatPagePersonalState extends State<ChatPagePersonal> {
  final TextEditingController _messageController = TextEditingController();

  //  z=  FirebaseFirestore.instance.collection('users').doc('GlobalChat').get(chat(['address', 'postcode']));

  var x;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    vaibhav();
  }

  bool goodies = true;
  bool userAccess = false;

  model.User? user;

  Future<void> vaibhav() async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.snap)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        x = documentSnapshot.data();
        widget.messages = x["Chat"];

        goodies = false;
      }
    });

    //widget.messages = widget.snap['chat'];
    if (!userAccess) {
      user =
          await AuthMethods().getUser(FirebaseAuth.instance.currentUser!.uid);
      userAccess = true;
    }
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
  }

  void sendMessage() {
    FirebaseFirestore.instance.collection("chats").doc(widget.snap).update({
      "Chat": FieldValue.arrayUnion([
        {
          "chatData": _messageController.text,
          "datetime": DateTime.now(),
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "photoUrl": user!.photoUrl
        }
      ])
    });
    _messageController.clear();
  }

  ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    if (goodies) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.snap)
          .snapshots()
          .listen((event) {
        print("loove");
        vaibhav();
      });
    }
    goodies = true;

    if (!isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text(user!.username)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.messages?.length ?? 0,
                  itemBuilder: (context, index) {
                    return widget.messages![widget.messages!.length - index - 1]
                                ["uid"] ==
                            FirebaseAuth.instance.currentUser!.uid
                        ? SenderRowView(
                            senderMessage: widget
                                .messages![widget.messages!.length - index - 1],
                          )
                        : ReceiverRowView(
                            receiverMessage: widget
                                .messages![widget.messages!.length - index - 1],
                          );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                        ),
                      ),
                    ),
                    //

                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          sendMessage();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
